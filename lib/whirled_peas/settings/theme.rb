require 'whirled_peas/utils/title_font'

require_relative 'bg_color'
require_relative 'border'
require_relative 'text_color'

module WhirledPeas
  module Settings
    class Theme
      attr_reader :bg_color, :border_style, :color, :title_font

      def axis_color=(value)
        @axis_color = TextColor.validate!(value)
      end

      def axis_color
        @axis_color || border_color
      end

      def bg_color=(value)
        @bg_color = BgColor.validate!(value)
      end

      def border_color=(value)
        @border_color = TextColor.validate!(value)
      end

      def border_color
        @border_color || color
      end

      def border_style=(value)
        @border_style = Border::Styles.validate!(value)
      end

      def color=(value)
        @color = TextColor.validate!(value)
      end

      def highlight_bg_color=(value)
        @highlight_bg_color = BgColor.validate!(value)
      end

      def highlight_bg_color
        @highlight_bg_color || color.as_bg_color
      end

      def highlight_color=(value)
        @highlight_color = TextColor.validate!(value)
      end

      def highlight_color
        @highlight_color || bg_color.as_text_color
      end

      def title_font=(value)
        @title_font = Utils::TitleFont.validate!(value)
      end
    end
  end
end
