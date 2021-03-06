module WhirledPeas
  module Graphics
    class ContainerDimensions
      attr_reader :children_width, :children_height, :num_cols, :num_rows

      def initialize(settings, content_width, content_height, num_cols=1, num_rows=1)
        @orig_content_width = content_width
        @orig_content_height = content_height
        @children_width = content_width
        @children_height = content_height
        @num_cols = num_cols
        @num_rows = num_rows
        @settings = settings
      end

      def content_width
        return orig_content_width unless settings.width
        if settings.border_sizing?
          settings.width - outer_border_width - scrollbar_width - padding_width
        else
          settings.width
        end
      end

      def content_height
        return orig_content_height unless settings.height
        if settings.border_sizing?
          settings.height - outer_border_height - scrollbar_height - padding_height
        else
          settings.height
        end
      end

      def inner_grid_width
        settings.padding.left +
          content_width +
          settings.padding.right
      end

      def grid_width
        (settings.border.inner_vert? ? 1 : 0) +
          inner_grid_width +
          (settings.scrollbar.vert? ? 1 : 0)
      end

      def inner_grid_height
        settings.padding.top +
          content_height +
          settings.padding.bottom
      end

      def grid_height
        (settings.border.inner_horiz? ? 1 : 0) +
          inner_grid_height +
          (settings.scrollbar.horiz? ? 1 : 0)
      end

      def outer_width
        @outer_width ||= margin_width +
          outer_border_width +
          num_cols * (padding_width + content_width + scrollbar_width) +
          (num_cols - 1) * inner_border_width
      end

      def outer_height
        @outer_height ||= margin_height +
          outer_border_height +
          num_rows * (padding_height + content_height + scrollbar_height) +
          (num_rows - 1) * inner_border_height
      end

      def margin_width
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

      def scrollbar_width
        settings.scrollbar.vert? ? 1 : 0
      end

      def scrollbar_height
        settings.scrollbar.horiz? ? 1 : 0
      end

      private

      attr_reader :settings, :orig_content_width, :orig_content_height
    end
  end
end
