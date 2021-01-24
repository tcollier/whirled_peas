require_relative 'container_painter'
require_relative 'container_dimensions'

module WhirledPeas
  module Graphics
    class BoxPainter < ContainerPainter
      def paint(canvas, &block)
        super
        return unless canvas.writable?
        stroke_top = coords(canvas).content_top
        stroke_left = coords(canvas).content_left
        greedy_width = element.settings.vertical_flow? || element.num_children == 1
        each_child do |child|
          if greedy_width
            width = dimensions.content_width
            height = child.dimensions.outer_height
          else
            width = child.dimensions.outer_width
            height = dimensions.content_height
          end
          child_canvas = canvas.child(stroke_left, stroke_top, width, height)
          child.paint(child_canvas, &block)
          if element.settings.horizontal_flow?
            stroke_left += child.dimensions.outer_width
          else
            stroke_top += child.dimensions.outer_height
          end
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
    end
    private_constant :BoxPainter
  end
end
