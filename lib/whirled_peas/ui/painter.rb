require 'whirled_peas/settings/text_align'
require 'whirled_peas/template/box_element'
require 'whirled_peas/template/grid_element'
require 'whirled_peas/template/text_element'
require 'whirled_peas/utils/ansi'

require_relative 'canvas'

module WhirledPeas
  module UI
    class TextPainter
      JUSTIFICATION = ' '

      def initialize(text, canvas)
        @text = text
        @canvas = canvas
      end

      def paint(&block)
        text.content.each.with_index do |line, index|
          yield canvas.stroke(canvas.left, canvas.top + index, justified(line))
        end
      end

      private

      attr_reader :text, :canvas

      def visible(line)
        if line.length <= text.dimensions.content_width
          line
        elsif text.settings.align == Settings::TextAlign::LEFT
          line[0..text.dimensions.content_width - 1]
        elsif text.settings.align == Settings::TextAlign::CENTER
          left_chop = (line.length - text.dimensions.content_width) / 2
          right_chop = line.length - text.dimensions.content_width - left_chop
          line[left_chop..-right_chop - 1]
        else
          line[-text.dimensions.content_width..-1]
        end
      end

      def justified(line)
        format_settings = [*text.settings.color, *text.settings.bg_color]
        format_settings << Utils::Ansi::BOLD if text.settings.bold?
        format_settings << Utils::Ansi::UNDERLINE if text.settings.underline?

        # ljust = case text.settings.align
        # when Settings::TextAlign::LEFT
        #   0
        # when Settings::TextAlign::CENTER
        #   [0, (text.dimensions.content_width - line.length) / 2].max
        # when Settings::TextAlign::RIGHT
        #   [0, text.dimensions.content_width - line.length].max
        # end
        # rjust = [0, text.dimensions.content_width - line.length - ljust].max
        # Utils::Ansi.format(JUSTIFICATION * ljust, [*text.settings.bg_color]) +
        #   Utils::Ansi.format(visible(line), format_settings) +
        #   Utils::Ansi.format(JUSTIFICATION * rjust, [*text.settings.bg_color])
        Utils::Ansi.format(line, format_settings)
      end
    end
    private_constant :TextPainter

    class ContainerPainter
      PADDING = ' '

      def initialize(container, canvas)
        @container = container
        @settings = container.settings
        @dimensions = container.dimensions
        @canvas = canvas
      end

      def paint(&block)
        return if dimensions.num_rows == 0 || dimensions.num_cols == 0
        top = canvas.top + settings.margin.top
        if settings.auto_margin?
          left = canvas.left + (canvas.width - dimensions.outer_width) / 2
        else
          left = canvas.left + settings.margin.left
        end
        if settings.border.top?
          yield canvas.stroke(left, top, top_border)
          top += 1
        end
        dimensions.num_rows.times do |row_num|
          if row_num > 0 && settings.border.inner_horiz?
            yield canvas.stroke(left, top, middle_border)
            top += 1
          end
          (settings.padding.top + dimensions.content_height + settings.padding.bottom).times do
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

      attr_reader :container, :settings, :canvas, :dimensions

      def line_stroke(left_border, horiz_border, junc_border, right_border)
        stroke = ''
        stroke += left_border if settings.border.left?
        dimensions.num_cols.times do |col_num|
          stroke += junc_border if col_num > 0 && settings.border.inner_vert?
          stroke += horiz_border * (dimensions.content_width + settings.padding.left + settings.padding.right)
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

    class BoxPainter
      def initialize(box, canvas)
        @box = box
        @canvas = canvas
      end

      def paint(&block)
        ContainerPainter.new(box, canvas).paint(&block)
        top = canvas.top + box.settings.margin.top + (box.settings.border.top? ? 1 : 0) + box.settings.padding.top
        if box.settings.auto_margin?
          margin = (canvas.width - box.dimensions.outer_width) / 2
        else
          margin = box.settings.margin.left
        end
        left = canvas.left + margin + (box.settings.border.left? ? 1 : 0) + box.settings.padding.left
        greedy_width = box.settings.vertical_flow? || box.num_children == 1
        box.each_child do |child|
          if greedy_width
            width = box.dimensions.content_width
            height = child.dimensions.outer_height
          else
            width = child.dimensions.outer_width
            height = box.dimensions.content_height
          end
          child_canvas = Canvas.new(left, top, width, height)
          Painter.paint(child, child_canvas, &block)
          if box.settings.horizontal_flow?
            left += child.dimensions.outer_width
          else
            top += child.dimensions.outer_height
          end
        end
      end

      private

      attr_reader :box, :canvas
    end

    class GridPainter
      def initialize(grid, canvas)
        @grid = grid
        @canvas = canvas
        available_width = grid.dimensions.outer_width - (grid.settings.margin.left || 0) - (grid.settings.margin.right || 0)
        @num_cols = grid.settings.num_cols || (available_width - (grid.settings.border.left? ? 1 : 0) - (grid.settings.border.right? ? 1 : 0) + (grid.border.inner_vert ? 1 : 0)) / (dimensions.content_width + grid.settings.padding.left + grid.settings.right + (grid.border.inner_vert ? 1 : 0))
      end

      def paint(&block)
        ContainerPainter.new(grid, canvas).paint(&block)

        top = canvas.top + grid.settings.margin.top + (grid.settings.border.top? ? 1 : 0) + grid.settings.padding.top
        if grid.settings.auto_margin?
          margin = (canvas.width - grid.dimensions.outer_width) / 2
        else
          margin = grid.settings.margin.left
        end
        left = canvas.left + margin + (grid.settings.border.left? ? 1 : 0) + grid.settings.padding.left
        grid_height = grid.settings.padding.top + grid.dimensions.content_height + grid.settings.padding.bottom + (grid.settings.border.inner_horiz? ? 1 : 0)
        grid_width = grid.settings.padding.left + grid.dimensions.content_width + grid.settings.padding.right + (grid.settings.border.inner_vert? ? 1 : 0)
        grid.each_child.with_index do |element, index|
          row_num = index / grid.dimensions.num_cols
          col_num = index % grid.dimensions.num_cols
          row_top = top + row_num * grid_height
          col_left = left + col_num * grid_width
          child_canvas = Canvas.new(
            col_left,
            row_top,
            element.dimensions.outer_width,
            element.dimensions.outer_height
          )
          Painter.paint(element, child_canvas, &block)
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
        PAINTERS[element.class].new(element, canvas).paint(&block)
      end
    end
  end
end
