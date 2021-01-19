require_relative 'settings'
require_relative 'ansi'

module WhirledPeas
  module UI
    DEBUG_SPACING = ARGV.include?('--debug-spacing')

    Canvas = Struct.new(:top, :left, :width, :height)

    Stroke = Struct.new(:top, :left, :chars)

    class MarginPainter
      MARGIN = DEBUG_SPACING ? 'm' : ' '

      def initialize(margin, bg_color, container_width, contained_width)
        @margin = margin
        @bg_color = bg_color
        @container_width = container_width
        @contained_width = contained_width
      end

      def paint_top(&block)
        margin.top.times { draw_empty_margin(&block) }
      end

      def left
        format(left_margin_size)
      end

      def right
        format(right_margin_size)
      end

      def paint_bottom(&block)
        margin.top.times { draw_empty_margin(&block) }
      end

      private

      attr_reader :margin, :bg_color, :container_width, :contained_width

      def paint_empty_margin(&block)
        yield format(left_margin_size + contained_width + right_margin_size)
      end

      def format(width)
        Ansi.format(MARGIN * width, [*bg_color])
      end

      def left_margin_size
        if margin.auto?
          (container_width - contained_width) / 2
        else
          margin.left
        end
      end

      def right_margin_size
        if margin.auto?
          container_width - contained_width - left_margin
        else
          margin.right
        end
      end
    end
    private_constant :MarginPainter

    class BorderPainter
      attr_reader :width

      def initialize(border, bg_color, contained_width)
        @border = border
        @bg_color = bg_color
        @contained_width = contained_width
        @width = contained_width + (border.left? ? 1 : 0) + (border.right? ? 1 : 0)
      end

      def paint_top(&block)
        if border.top?
          yield horizontal_border(
            border.left? ? border.style.top_left : '',
            border.style.top_horiz,
            border.right? ? border.style.top_right : '',
          )
        end
      end

      def left
        border.left? ? format(border.style.left_vert) : ''
      end

      def right
        border.right? ? format(border.style.right_vert) : ''
      end

      def paint_bottom(&block)
        if border.bottom?
          yield horizontal_border(
            border.left? ? border.style.bottom_left : '',
            border.style.bottom_horiz,
            border.right? ? border.style.bottom_right : ''
          )
        end
      end

      private

      attr_reader :border, :bg_color, :contained_width

      def horizontal_border(start_corner, horizontal, end_corner)
        format(start_corner + horizontal * contained_width + end_corner)
      end

      def format(str)
        Ansi.format(str, [*bg_color, *border.color])
      end
    end
    private_constant :BorderPainter

    class PaddingPainter
      PADDING = DEBUG_SPACING ? 'p' : ' '

      attr_reader :width

      def initialize(padding, bg_color, contained_width)
        @padding = padding
        @bg_color = bg_color
        @contained_width = contained_width
        @width = contained_width + padding.left + padding.right
      end

      def paint_top(&block)
        padding.top.times do
          yield format(padding.left + contained_width + padding.right)
        end
      end

      def left
        format(padding.left)
      end

      def right
        format(padding.right)
      end

      def paint_bottom(&block)
        padding.bottom.times do
          yield format(padding.left + contained_width + padding.right)
        end
      end

      private

      attr_reader :padding, :bg_color, :contained_width

      def format(width)
        Ansi.format(PADDING * width, [*bg_color])
      end
    end
    private_constant :PaddingPainter

    class TextPainter
      JUSTIFICATION = DEBUG_SPACING ? 'j' : ' '

      def initialize(text, canvas)
        @text = text
        @canvas = canvas
        @width = text.settings.width || text.preferred_width
      end

      def paint(&block)
        yield Stroke.new(canvas.top, canvas.left, justified)
      end

      private

      attr_reader :text, :canvas, :width

      def visible
        if text.preferred_width <= width
          text.value
        elsif text.settings.align == TextAlign::LEFT
          text.value[0..width - 1]
        elsif text.settings.align == TextAlign::CENTER
          left_chop = (text.preferred_width - width) / 2
          right_chop = text.preferred_width - width - left_chop
          text.value[left_chop..-right_chop - 1]
        else
          text.value[-width..-1]
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
          [0, (width - text.preferred_width) / 2].max
        when TextAlign::RIGHT
          [0, width - text.preferred_width].max
        end
        rjust = [0, width - text.preferred_width - ljust].max
        Ansi.format(JUSTIFICATION * ljust, [*text.settings.bg_color]) +
          Ansi.format(visible, format_settings) +
          Ansi.format(JUSTIFICATION * rjust, [*text.settings.bg_color])
      end
    end
    private_constant :TextPainter

    class BoxPainter
      def initialize(box, canvas)
        @box = box
        @canvas = canvas
        # @padding = PaddingPainter.new(box.settings.padding, box.settings.bg_color, box.width)
        # @border = BorderPainter.new(box.settings.border, box.settings.bg_color, @padding.width)
        # @margin = MarginPainter.new(box.settings.margin, box.settings.bg_color, canvas.width, @border.width)
      end

      def paint(&block)
        # margin.paint_top(&block)
        # border.paint_top { |line| yield margin.left + line + margin.right }
        # padding.paint_top { |line| yield margin.left + border.left + line + border.right + margin.right }
        left = canvas.left
        box.children.each do |child|
          child_canvas = Canvas.new(
            canvas.top,
            left,
            child.preferred_width,
            1
          )
          Painter.paint(child, child_canvas, &block)
          left += child.preferred_width
        end
        # box.content.paint(box.width, box.settings) { |line| draw_content_line(line, &block) }
        # padding.paint_bottom { |line| yield margin.left + border.left + line + border.right + margin.right }
        # border.paint_bottom { |line| yield margin.left + line + margin.right }
        # margin.paint_bottom(&block)
      end

      private

      attr_reader :box, :canvas, :padding, :border, :margin

      def paint_content_line(line, &block)
        yield margin.left +
          border.left +
          padding.left +
          justify(line) +
          padding.right +
          border.right +
          margin.right
      end
    end

    class GridPainter
      def initialize(grid, canvas)
        @grid = grid
        @canvas = canvas
        available_width = grid.preferred_width - (grid.settings.margin.left || 0) - (grid.settings.margin.right || 0)
        @num_cols = grid.settings.num_cols || (available_width - (grid.settings.border.left? ? 1 : 0) - (grid.settings.border.right? ? 1 : 0) + (grid.border.inner_vert ? 1 : 0)) / (cell_width + grid.settings.padding.left + grid.settings.right + (grid.border.inner_vert ? 1 : 0))
        # @padding = PaddingPainter.new(grid.settings.padding, grid.settings.bg_color, grid.cell_width)
        # @border = BorderPainter.new(grid.settings.border, grid.settings.bg_color, @padding.width)
        # @margin = MarginPainter.new(grid.settings.margin, grid.settings.bg_color, container_width, available_width)
      end

      def paint(&block)
        return if grid.children.empty?
        children = grid.children
        # children = if grid.settings.transpose
        #   grid.children.length.times.map do |i|
        #     grid.children[(i * num_cols) % grid.children.length +  i / (grid.children.length / num_cols)]
        #   end.compact
        # else
        #   grid.children
        # end

        children.each_slice(num_cols).each.with_index do |row, row_num|
          row.each.with_index do |element, col_num|
            child_canvas = Canvas.new(
              canvas.left + (col_num * grid.cell_width),
              canvas.top + row_num,
              grid.cell_width,
              1
            )
            Painter.paint(element, child_canvas, &block)
          end
        end
      end

      private

      attr_reader :grid, :canvas, :num_cols, :padding, :border, :margin
    end

    module Painter
      PAINTERS = {
        TextElement => TextPainter,
        BoxElement => BoxPainter,
        GridElement => GridPainter,
      }

      def self.paint(element, canvas, &block)
        if element.is_a?(Template)
          new_element = BoxElement.new(BoxSettings.new.merge(element.settings))
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
