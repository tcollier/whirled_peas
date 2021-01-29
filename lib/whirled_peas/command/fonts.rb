require_relative 'base'

module WhirledPeas
  module Command
    # List title fonts installed on the user's system and print sample text in each.
    class Fonts < Base
      def self.description
        'List installed title fonts with sample text'
      end

      def start
        require 'whirled_peas/utils/title_font'

        Utils::TitleFont.fonts.keys.each do |key|
          puts Utils::TitleFont.to_s(key.to_s, key)
          puts key.inspect
          puts
        end
      end
    end
  end
end
