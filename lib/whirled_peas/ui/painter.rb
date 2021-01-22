require 'whirled_peas/settings/text_align'
require 'whirled_peas/template/element'
require 'whirled_peas/utils/ansi'

require_relative 'canvas'

module WhirledPeas
  module UI
    DEBUG_SPACING = ARGV.include?('--debug-spacing')

    class TextPainter
      JUSTIFICATION = DEBUG_SPACING ? 'j' : ' '

      def initialize(text, canvas)
        @text = text
        @canvas = canvas
      end

      def paint(&block)
        text.lines.each.with_index do |line, index|
          yield canvas.stroke(canvas.left, canvas.top + index, justified(line))
        end
      end

      private

      attr_reader :text, :canvas

      def visible(line)
        if line.length <= text.preferred_width
          line
        elsif text.settings.align == Settings::TextAlign::LEFT
          line[0..text.preferred_width - 1]
        elsif text.settings.align == Settings::TextAlign::CENTER
          left_chop = (line.length - text.preferred_width) / 2
          right_chop = line.length - text.preferred_width - left_chop
          line[left_chop..-right_chop - 1]
        else
          line[-text.preferred_width..-1]
        end
      end

      def justified(line)
        format_settings = [*text.settings.color, *text.settings.bg_color]
        format_settings << Utils::Ansi::BOLD if text.settings.bold?
        format_settings << Utils::Ansi::UNDERLINE if text.settings.underline?

        ljust = case text.settings.align
        when Settings::TextAlign::LEFT
          0
        when Settings::TextAlign::CENTER
          [0, (text.preferred_width - line.length) / 2].max
        when Settings::TextAlign::RIGHT
          [0, text.preferred_width - line.length].max
        end
        rjust = [0, text.preferred_width - line.length - ljust].max
        Utils::Ansi.format(JUSTIFICATION * ljust, [*text.settings.bg_color]) +
          Utils::Ansi.format(visible(line), format_settings) +
          Utils::Ansi.format(JUSTIFICATION * rjust, [*text.settings.bg_color])
      end
    end
    private_constant :TextPainter

    class ContainerPainter
      PADDING = DEBUG_SPACING ? 'p' : ' '

      def initialize(container, canvas)
        @container = container
        @settings = container.settings
        @canvas = canvas
      end

      def paint(&block)
        return if container.num_rows == 0 || container.num_cols == 0
        top = canvas.top + settings.margin.top
        if settings.auto_margin?
          left = canvas.left + (canvas.width - container.preferred_width) / 2
        else
          left = canvas.left + settings.margin.left
        end
        if settings.border.top?
          yield canvas.stroke(left, top, top_border)
          top += 1
        end
        container.num_rows.times do |row_num|
          if row_num > 0 && settings.border.inner_horiz?
            yield canvas.stroke(left, top, middle_border)
            top += 1
          end
          (settings.padding.top + container.row_height + settings.padding.bottom).times do
            yield canvas.stroke(left, top, content_line)
            top += 1
          end
        end
        if settings.border.bottom?
          yield canvas.stroke(left, top, bottom_border)
          top += 1
        end
      end

      private

      attr_reader :container, :settings, :canvas

      def line_stroke(left_border, horiz_border, junc_border, right_border)
        stroke = ''
        stroke += left_border if settings.border.left?
        container.num_cols.times do |col_num|
          stroke += junc_border if col_num > 0 && settings.border.inner_vert?
          stroke += horiz_border * (container.col_width + settings.padding.left + settings.padding.right)
        end
        stroke += right_border if settings.border.right?
        Utils::Ansi.format(stroke, [*settings.border.color, *settings.bg_color])
      end

      def top_border
        line_stroke(
          settings.border.style.top_left,
          settings.border.style.top_horiz,
          settings.border.style.top_junc,
          settings.border.style.top_right
        )
      end

      def content_line
        line_stroke(
          settings.border.style.left_vert,
          PADDING,
          settings.border.style.middle_vert,
          settings.border.style.right_vert
        )
      end

      def middle_border
        line_stroke(
          settings.border.style.left_junc,
          settings.border.style.middle_horiz,
          settings.border.style.cross_junc,
          settings.border.style.right_junc
        )
      end

      def bottom_border
        line_stroke(
          settings.border.style.bottom_left,
          settings.border.style.bottom_horiz,
          settings.border.style.bottom_junc,
          settings.border.style.bottom_right
        )
      end
    end

    class BoxContainer
      attr_reader :settings, :num_cols, :num_rows, :col_width, :row_height, :preferred_width

      def initialize(box)
        @settings = Settings::ContainerSettings.cast(box.settings)
        @num_cols = 1
        @num_rows = 1
        @col_width = box.content_width
        @row_height = box.content_height
        @preferred_width = box.preferred_width
      end
    end

    class BoxPainter
      def initialize(box, canvas)
        @box = box
        @canvas = canvas
      end

      def paint(&block)
        container = BoxContainer.new(box)
        ContainerPainter.new(container, canvas).paint(&block)
        top = canvas.top + box.settings.margin.top + (box.settings.border.top? ? 1 : 0) + box.settings.padding.top
        if box.settings.auto_margin?
          margin = (canvas.width - box.preferred_width) / 2
        else
          margin = box.settings.margin.left
        end
        left = canvas.left + margin + (box.settings.border.left? ? 1 : 0) + box.settings.padding.left
        greedy_width = box.settings.vertical_flow? || box.children.length == 1
        children = box.children
        children = children.reverse if box.settings.reverse_flow?
        children.each do |child|
          if greedy_width
            width = box.content_width
            height = child.preferred_height
          else
            width = child.preferred_width
            height = box.content_height
          end
          child_canvas = Canvas.new(left, top, width, height)
          Painter.paint(child, child_canvas, &block)
          if box.settings.horizontal_flow?
            left += child.preferred_width
          else
            top += child.preferred_height
          end
        end
      end

      private

      attr_reader :box, :canvas
    end

    class GridContainer
      attr_reader :settings, :num_cols, :num_rows, :col_width, :row_height, :preferred_width

      def initialize(grid, num_cols, num_rows)
        @settings = Settings::ContainerSettings.cast(grid.settings)
        @num_cols = num_cols
        @num_rows = num_rows
        @col_width = grid.col_width
        @row_height = grid.row_height
        @preferred_width = grid.preferred_width
      end
    end

    class GridPainter
      def initialize(grid, canvas)
        @grid = grid
        @canvas = canvas
        available_width = grid.preferred_width - (grid.settings.margin.left || 0) - (grid.settings.margin.right || 0)
        @num_cols = grid.settings.num_cols || (available_width - (grid.settings.border.left? ? 1 : 0) - (grid.settings.border.right? ? 1 : 0) + (grid.border.inner_vert ? 1 : 0)) / (col_width + grid.settings.padding.left + grid.settings.right + (grid.border.inner_vert ? 1 : 0))
      end

      def paint(&block)
        return if grid.children.empty?

        container = GridContainer.new(grid, num_cols, (grid.children.length.to_f / num_cols).ceil)
        ContainerPainter.new(container, canvas).paint(&block)

        top = canvas.top + grid.settings.margin.top + (grid.settings.border.top? ? 1 : 0) + grid.settings.padding.top
        if grid.settings.auto_margin?
          margin = (canvas.width - grid.preferred_width) / 2
        else
          margin = grid.settings.margin.left
        end
        left = canvas.left + margin + (grid.settings.border.left? ? 1 : 0) + grid.settings.padding.left
        grid_height = grid.settings.padding.top + grid.row_height + grid.settings.padding.bottom + (grid.settings.border.inner_horiz? ? 1 : 0)
        grid_width = grid.settings.padding.left + grid.col_width + grid.settings.padding.right + (grid.settings.border.inner_vert? ? 1 : 0)
        grid.children.each_slice(num_cols).each.with_index do |row, row_num|
          row_top = top + row_num * grid_height
          row.each.with_index do |element, col_num|
            col_left = left + col_num * grid_width
            child_canvas = Canvas.new(
              col_left,
              row_top,
              element.preferred_width,
              element.preferred_height
            )
            Painter.paint(element, child_canvas, &block)
          end
        end
      end

      private

      attr_reader :grid, :canvas, :num_cols
    end

    module Painter
      PAINTERS = {
        Template::TextElement => TextPainter,
        Template::BoxElement => BoxPainter,
        Template::GridElement => GridPainter,
      }

      def self.paint(element, canvas, &block)
        if element.is_a?(Template::Template)
          element = Template::BoxElement.from_template(element, canvas.width, canvas.height)
        end
        PAINTERS[element.class].new(element, canvas).paint(&block)
      end
    end
  end
end
