require 'whirled_peas/utils/title_font'

require_relative 'element_settings'

module WhirledPeas
  module Settings
    class TextSettings < ElementSettings
      attr_reader :title_font

      def title_font=(font)
        font = theme.title_font if font == :theme
        @title_font = Utils::TitleFont.validate!(font)
      end
    end
  end
end
