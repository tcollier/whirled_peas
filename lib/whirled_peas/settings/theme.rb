require 'whirled_peas/utils/title_font'

require_relative 'bg_color'
require_relative 'text_color'

module WhirledPeas
  module Settings
    class Theme
      attr_reader :color, :bg_color, :title_font

      def color=(value)
        @color = TextColor.validate!(value)
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

      def axis_color=(value)
        @axis_color = TextColor.validate!(value)
      end

      def axis_color
        @axis_color || border_color
      end

      def title_font=(value)
        @title_font = Utils::TitleFont.validate!(value)
      end
    end
  end
end
