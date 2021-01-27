require_relative 'container_painter'
require_relative 'container_dimensions'

module WhirledPeas
  module Graphics
    class BoxPainter < ContainerPainter
      def paint(canvas, left, top, &block)
        super
        canvas_coords = coords(left, top)
        content_canvas = canvas.child(
          canvas_coords.content_left,
          canvas_coords.content_top,
          dimensions.content_width,
          dimensions.content_height
        )
        return unless content_canvas.writable?
        if settings.horizontal_flow?
          paint_horizontally(content_canvas, canvas_coords, &block)
        else
          paint_vertically(content_canvas, canvas_coords, &block)
        end
      end

      def dimensions
        @dimensions ||= begin
          content_width = 0
          content_height = 0
          if settings.horizontal_flow?
            each_child do |child|
              content_width += child.dimensions.outer_width
              if child.dimensions.outer_height > content_height
                content_height = child.dimensions.outer_height
              end
            end
          else
            each_child do |child|
              if child.dimensions.outer_width > content_width
                content_width = child.dimensions.outer_width
              end
              content_height += child.dimensions.outer_height
            end
          end
          ContainerDimensions.new(settings, content_width, content_height)
        end
      end

      def each_child(&block)
        if settings.reverse_flow?
          children.reverse.each(&block)
        else
          super
        end
      end

      private

      def paint_horizontally(canvas, canvas_coords, &block)
        stroke_left = canvas_coords.content_left
        stroke_top = canvas_coords.content_top
        children_width = 0
        each_child { |c| children_width += c.dimensions.outer_width }
        left_offset, spacing_offset = horiz_justify_offset(children_width)
        stroke_left += left_offset
        each_child do |child|
          top_offset, _ = vert_justify_offset(child.dimensions.outer_height)
          child_width = child.dimensions.outer_width
          child_canvas = canvas.child(
            stroke_left,
            stroke_top + top_offset,
            child_width,
            child.dimensions.outer_height
          )
          child.paint(child_canvas, stroke_left, stroke_top + top_offset, &block)
          stroke_left += child_width + spacing_offset
        end
      end

      def paint_vertically(canvas, canvas_coords, &block)
        stroke_left = canvas_coords.content_left
        stroke_top = canvas_coords.content_top
        children_height = 0
        each_child { |c| children_height += c.dimensions.outer_height }
        top_offset, spacing_offset = vert_justify_offset(children_height)
        stroke_top += top_offset
        each_child do |child|
          left_offset, _ = horiz_justify_offset(child.dimensions.outer_width)
          child_height = child.dimensions.outer_height
          child_canvas = canvas.child(
            stroke_left + left_offset,
            stroke_top ,
            child.dimensions.outer_width,
            child_height
          )
          child.paint(child_canvas, stroke_left + left_offset, stroke_top, &block)
          stroke_top += child_height + spacing_offset
        end
      end
    end
    private_constant :BoxPainter
  end
end
