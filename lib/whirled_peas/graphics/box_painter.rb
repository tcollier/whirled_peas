require_relative 'container_painter'
require_relative 'container_dimensions'

module WhirledPeas
  module Graphics
    class BoxPainter < ContainerPainter
      def paint(canvas, &block)
        super
        return unless canvas.writable?
        if settings.horizontal_flow?
          paint_horizontally(canvas, &block)
        else
          paint_vertically(canvas, &block)
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

      def paint_horizontally(canvas, &block)
        stroke_top = coords(canvas).content_top
        stroke_left = coords(canvas).content_left
        children_width = 0
        each_child { |c| children_width += c.dimensions.outer_width }
        start_offset, spacing_offset = justify_offset(children_width)
        stroke_left += start_offset
        given_width = 0
        each_child do |child|
          child_width = [
            child.dimensions.outer_width,
            dimensions.content_width - given_width
          ].min
          child_canvas = canvas.child(
            stroke_left + given_width,
            stroke_top,
            child_width,
            [dimensions.content_height, child.dimensions.outer_height].min
          )
          child.paint(child_canvas, &block)
          given_width += child_width + spacing_offset
          break if given_width == dimensions.content_width
        end
      end

      def paint_vertically(canvas, &block)
        stroke_top = coords(canvas).content_top
        stroke_left = coords(canvas).content_left
        given_height = 0
        each_child do |child|
          start_offset, _ = justify_offset(child.dimensions.outer_width)
          child_height = [
            child.dimensions.outer_height,
            dimensions.content_height - given_height
          ].min
          child_canvas = canvas.child(
            stroke_left + start_offset,
            stroke_top + given_height,
            [dimensions.content_width, child.dimensions.outer_width].min,
            child_height
          )
          child.paint(child_canvas, &block)
          given_height += child_height
          break if given_height == dimensions.content_height
        end
      end
    end
    private_constant :BoxPainter
  end
end
