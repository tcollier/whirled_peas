require_relative 'container'
require_relative 'container_dimensions'

module WhirledPeas
  module Template
    class GridElement < Container
      def dimensions
        @dimensions ||= begin
          num_cols = settings.num_cols
          num_rows = (num_children.to_f / num_cols).ceil
          content_width = 0
          each_child do |child|
            if child.dimensions.outer_width > content_width
              content_width = child.dimensions.outer_width
            end
          end
          content_height = 0
          each_child do |child|
            if child.dimensions.outer_height > content_height
              content_height = child.dimensions.outer_height
            end
          end
          ContainerDimensions.new(
            settings, content_width, content_height, num_cols, num_rows
          )
        end
      end
    end
  end
end
