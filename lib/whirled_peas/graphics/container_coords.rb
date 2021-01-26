module WhirledPeas
  module Graphics
    class ContainerCoords
      def initialize(canvas, dimensions, settings)
        @canvas = canvas
        @dimensions = dimensions
        @settings = settings
      end

      def left
        canvas.start_left + settings.position.left
      end

      def top
        canvas.start_top + settings.position.top
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
        padding_left + settings.padding.left + col_index * grid_width
      end

      def content_top(row_index=0)
        padding_top + settings.padding.top + row_index * grid_height
      end

      def inner_grid_width
        settings.padding.left +
          dimensions.content_width +
          settings.padding.right
      end

      def grid_width
        (settings.border.inner_vert? ? 1 : 0) +
          inner_grid_width +
          (settings.scrollbar.vert? ? 1 : 0)
      end

      def inner_grid_height
        settings.padding.top +
          dimensions.content_height +
          settings.padding.bottom
      end

      def grid_height
        (settings.border.inner_horiz? ? 1 : 0) +
          inner_grid_height +
          (settings.scrollbar.horiz? ? 1 : 0)
      end

      private

      attr_reader :canvas, :settings, :dimensions
    end
  end
end
