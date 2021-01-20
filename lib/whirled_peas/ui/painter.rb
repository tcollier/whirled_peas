require_relative 'settings'
require_relative 'ansi'

module WhirledPeas
  module UI
    DEBUG_SPACING = ARGV.include?('--debug-spacing')

    Canvas = Struct.new(:top, :left, :width, :height)

    Stroke = Struct.new(:top, :left, :chars)

    class TextPainter
      JUSTIFICATION = DEBUG_SPACING ? 'j' : ' '

      def initialize(text, canvas)
        @text = text
        @canvas = canvas
      end

      def paint(&block)
        yield Stroke.new(canvas.top, canvas.left, justified)
      end

      private

      attr_reader :text, :canvas

      def visible
        if text.value.length <= text.preferred_width
          text.value
        elsif text.settings.align == TextAlign::LEFT
          text.value[0..text.preferred_width - 1]
        elsif text.settings.align == TextAlign::CENTER
          left_chop = (text.value.length - text.preferred_width) / 2
          right_chop = text.value.length - text.preferred_width - left_chop
          text.value[left_chop..-right_chop - 1]
        else
          text.value[-text.preferred_width..-1]
        end
      end

      def justified
        format_settings = [*text.settings.color, *text.settings.bg_color]
        format_settings << TextFormat::BOLD if text.settings.bold?
        format_settings << TextFormat::UNDERLINE if text.settings.underline?

        ljust = case text.settings.align
        when TextAlign::LEFT
          0
        when TextAlign::CENTER
          [0, (text.preferred_width - text.value.length) / 2].max
        when TextAlign::RIGHT
          [0, text.preferred_width - text.value.length].max
        end
        rjust = [0, text.preferred_width - text.value.length - ljust].max
        Ansi.format(JUSTIFICATION * ljust, [*text.settings.bg_color]) +
          Ansi.format(visible, format_settings) +
          Ansi.format(JUSTIFICATION * rjust, [*text.settings.bg_color])
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
        left = canvas.left + settings.margin.left
        if settings.border.top?
          yield Stroke.new(top, left, top_border)
          top += 1
        end
        container.num_rows.times do |row_num|
          if row_num > 0 && settings.border.inner_horiz?
            yield Stroke.new(top, left, middle_border)
            top += 1
          end
          (settings.padding.top + container.row_height + settings.padding.bottom).times do
            yield Stroke.new(top, left, content_line)
            top += 1
          end
        end
        if settings.border.bottom?
          yield Stroke.new(top, left, bottom_border)
          top += 1
        end
      end

      private

      attr_reader :container, :settings, :canvas

      def line_stroke(left_border, horiz_border, junc_border, right_border)
        stroke = ''
        stroke += left_border if settings.border.left?
        container.num_cols.times do |col_num|
          stroke += junc_border if col_num > 0 && settings.border.inner_horiz?
          stroke += horiz_border * (container.col_width + settings.padding.left + settings.padding.right)
        end
        stroke += right_border if settings.border.right?
        Ansi.format(stroke, [*settings.border.color, *settings.bg_color])
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
      attr_reader :settings, :num_cols, :num_rows, :col_width, :row_height

      def initialize(box)
        @settings = ContainerSettings.merge(box.settings)
        @num_cols = 1
        @num_rows = 1
        @col_width = box.content_width
        @row_height = box.content_height
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
        left = canvas.left + box.settings.margin.left + (box.settings.border.left? ? 1 : 0) + box.settings.padding.left
        box.children.each do |child|
          child_canvas = Canvas.new(
            top,
            left,
            child.preferred_width,
            child.preferred_height
          )
          Painter.paint(child, child_canvas, &block)
          if box.settings.display_flow == :inline
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
      attr_reader :settings, :num_cols, :num_rows, :col_width, :row_height

      def initialize(grid, num_cols, num_rows)
        @settings = ContainerSettings.merge(grid.settings)
        @num_cols = num_cols
        @num_rows = num_rows
        @col_width = grid.col_width
        @row_height = grid.row_height
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

        children = if grid.settings.transpose?
          grid.children.length.times.map do |i|
            grid.children[(i * num_cols) % grid.children.length +  i / (grid.children.length / num_cols)]
          end.compact
        else
          grid.children
        end

        top = canvas.top + grid.settings.margin.top + (grid.settings.border.top? ? 1 : 0) + grid.settings.padding.top
        left = canvas.left + grid.settings.margin.left + (grid.settings.border.left? ? 1 : 0) + grid.settings.padding.left
        grid_height = grid.settings.padding.top + grid.row_height + grid.settings.padding.bottom + (grid.settings.border.inner_horiz? ? 1 : 0)
        grid_width = grid.settings.padding.left + grid.col_width + grid.settings.padding.right + (grid.settings.border.inner_vert? ? 1 : 0)
        children.each_slice(num_cols).each.with_index do |row, row_num|
          row_top = top + row_num * grid_height
          row.each.with_index do |element, col_num|
            col_left = left + col_num * grid_width
            child_canvas = Canvas.new(
              row_top,
              col_left,
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
        TextElement => TextPainter,
        BoxElement => BoxPainter,
        GridElement => GridPainter,
      }

      def self.paint(element, canvas, &block)
        if element.is_a?(Template)
          new_element = BoxElement.new(BoxSettings.merge(element.settings))
          element.children.each do |child|
            new_element.children << child
          end
          element = new_element
        end
        PAINTERS[element.class].new(element, canvas).paint(&block)
      end
    end
  end
end
