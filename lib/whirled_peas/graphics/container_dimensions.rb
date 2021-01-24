module WhirledPeas
  module Graphics
    class ContainerDimensions
      attr_reader :content_width, :content_height, :num_cols, :num_rows

      def initialize(settings, content_width, content_height, num_cols=1, num_rows=1)
        @content_width = content_width
        @content_height = content_height
        @num_cols = num_cols
        @num_rows = num_rows
        @settings = settings
      end

      def outer_width
        @outer_width ||= margin_width +
          outer_border_width +
          num_cols * (padding_width + content_width) +
          (num_cols - 1) * inner_border_width
      end

      def outer_height
        @outer_height ||= margin_height +
          outer_border_height +
          num_rows * (padding_height + content_height) +
          (num_rows - 1) * inner_border_height
      end

      private

      attr_reader :settings

      def margin_width
        return 0 if settings.auto_margin?
        settings.margin.left + settings.margin.right
      end

      def margin_height
        settings.margin.top + settings.margin.bottom
      end

      def outer_border_width
        (settings.border.left? ? 1 : 0) + (settings.border.right? ? 1 : 0)
      end

      def outer_border_height
        (settings.border.top? ? 1 : 0) + (settings.border.bottom? ? 1 : 0)
      end

      def inner_border_width
        settings.border.inner_vert? ? 1 : 0
      end

      def inner_border_height
        settings.border.inner_horiz? ? 1 : 0
      end

      def padding_width
        settings.padding.left + settings.padding.right
      end

      def padding_height
        settings.padding.top + settings.padding.bottom
      end
    end
  end
end
