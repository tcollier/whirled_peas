require 'whirled_peas/utils/formatted_string'

require_relative 'container_coords'
require_relative 'painter'

module WhirledPeas
  module Graphics
    class ContainerPainter < Painter
      PADDING = ' '

      def initialize(name, settings)
        super
        @children = []
      end

      def paint(canvas, &block)
        return unless canvas.writable?
        has_inner_vert = dimensions.num_cols > 1 && settings.border.inner_vert?
        has_inner_horiz = dimensions.num_rows > 1 && settings.border.inner_horiz?
        has_border = settings.border.outer? || has_inner_vert || has_inner_horiz
        return unless settings.bg_color || has_border
        stroke_left = coords(canvas).border_left
        stroke_top = coords(canvas).border_top
        formatting = [*settings.border.color, *settings.bg_color]
        if settings.border.top?
          canvas.stroke(stroke_left, stroke_top, top_border_stroke, formatting, &block)
          stroke_top += 1
        end
        content_line = content_line_stroke
        middle_border = dimensions.num_rows > 1 ? middle_border_stroke : ''
        dimensions.num_rows.times do |row_num|
          if row_num > 0 && settings.border.inner_horiz?
            canvas.stroke(stroke_left, stroke_top, middle_border, formatting, &block)
            stroke_top += 1
          end
          coords(canvas).grid_height(false).times do
            canvas.stroke(stroke_left, stroke_top, content_line, formatting, &block)
            stroke_top += 1
          end
        end
        if settings.border.bottom?
          canvas.stroke(stroke_left, stroke_top, bottom_border_stroke, formatting, &block)
          stroke_top += 1
        end
      end

      def add_child(child)
        children << child
      end

      def num_children
        children.length
      end

      def children?
        num_children > 0
      end

      def each_child(&block)
        children.each(&block)
      end

      private

      attr_reader :children

      def coords(canvas)
        ContainerCoords.new(canvas, dimensions, settings)
      end

      def line_stroke(left_border, horiz_border, junc_border, right_border)
        stroke = ''
        stroke += left_border if settings.border.left?
        dimensions.num_cols.times do |col_num|
          stroke += junc_border if col_num > 0 && settings.border.inner_vert?
          stroke += horiz_border * (dimensions.content_width + settings.padding.left + settings.padding.right)
        end
        stroke += right_border if settings.border.right?
        stroke
      end

      def top_border_stroke
        line_stroke(
          settings.border.style.top_left,
          settings.border.style.top_horiz,
          settings.border.style.top_junc,
          settings.border.style.top_right
        )
      end

      def content_line_stroke
        line_stroke(
          settings.border.style.left_vert,
          PADDING,
          settings.border.style.middle_vert,
          settings.border.style.right_vert
        )
      end

      def middle_border_stroke
        line_stroke(
          settings.border.style.left_junc,
          settings.border.style.middle_horiz,
          settings.border.style.cross_junc,
          settings.border.style.right_junc
        )
      end

      def bottom_border_stroke
        line_stroke(
          settings.border.style.bottom_left,
          settings.border.style.bottom_horiz,
          settings.border.style.bottom_junc,
          settings.border.style.bottom_right
        )
      end
    end
    private_constant :ContainerPainter
  end
end
