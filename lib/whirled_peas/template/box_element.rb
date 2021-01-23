require_relative 'container'
require_relative 'container_dimensions'

module WhirledPeas
  module Template
    class BoxElement < Container
      def each_child(&block)
        kids = settings.reverse_flow? ? @children.reverse : @children
        kids.each(&block)
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
  end
end
