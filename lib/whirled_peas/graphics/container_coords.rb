module WhirledPeas
  module Graphics
    class ContainerCoords
      def initialize(dimensions, settings, start_left, start_top)
        @dimensions = dimensions
        @settings = settings
        @start_left = start_left
        @start_top = start_top
      end

      def left
        start_left
      end

      def top
        start_top
      end

      def border_left
        left + settings.margin.left
      end

      def border_top
        top + settings.margin.top
      end

      def padding_left
        border_left + (settings.border.left? ? 1 : 0)
      end

      def padding_top
        border_top + (settings.border.top? ? 1 : 0)
      end

      def content_left(col_index=0)
        padding_left + settings.padding.left + col_index * dimensions.grid_width
      end

      def offset_content_left(col_index=0)
        if settings.content_start.left
          content_left(col_index) + settings.content_start.left
        elsif settings.content_start.right
          left_offset = dimensions.content_width - dimensions.children_width
          content_left(col_index) + left_offset - settings.content_start.right
        else
          content_left(col_index)
        end
      end

      def content_top(row_index=0)
        padding_top + settings.padding.top + row_index * dimensions.grid_height
      end

      def offset_content_top(row_index=0)
        if settings.content_start.top
          content_top(row_index) + settings.content_start.top
        elsif settings.content_start.bottom
          top_offset = dimensions.content_height - dimensions.children_height
          content_top(row_index) + top_offset - settings.content_start.bottom
        else
          content_top(row_index)
        end
      end

      private

      attr_reader :settings, :dimensions, :start_left, :start_top
    end
  end
end
