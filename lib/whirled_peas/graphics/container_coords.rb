module WhirledPeas
  module Graphics
    class ContainerCoords
      def initialize(canvas, dimensions, settings)
        @canvas = canvas
        @dimensions = dimensions
        @settings = settings
      end

      def left
        canvas.left
      end

      def top
        canvas.top
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
        padding_left + settings.padding.left + col_index * grid_width(true)
      end

      def content_top(row_index=0)
        padding_top + settings.padding.top + row_index * grid_height(true)
      end

      def grid_width(include_border)
        (include_border && settings.border.inner_vert? ? 1 : 0) +
          settings.padding.left +
          dimensions.content_width +
          settings.padding.right
      end

      def grid_height(include_border)
        (include_border && settings.border.inner_horiz? ? 1 : 0) +
          settings.padding.top +
          dimensions.content_height +
          settings.padding.bottom
      end

      private

      attr_reader :canvas, :settings, :dimensions
    end
  end
end
