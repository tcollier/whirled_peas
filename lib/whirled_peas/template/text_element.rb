require 'whirled_peas/utils/title_font'

require_relative 'element'
require_relative 'text_dimensions'

module WhirledPeas
  module Template
    class TextElement < Element
      # List of classes that convert nicely to a string
      STRINGALBE_CLASSES = [FalseClass, Float, Integer, NilClass, String, Symbol, TrueClass]
      private_constant :STRINGALBE_CLASSES

      def self.stringable?(value)
        STRINGALBE_CLASSES.include?(value.class)
      end

      attr_reader :content

      def content=(val)
        unless self.class.stringable?(val)
          raise ArgumentError, "Unsupported type for TextElement: #{val.class}"
        end
        if settings.title_font
          @content = Utils::TitleFont.to_s(val.to_s, settings.title_font).split("\n")
        else
          @content = [val.to_s]
        end
      end

      def dimensions
        TextDimensions.new(@content.first.length, @content.length)
      end

      def inspect(indent='')
        dims = unless preferred_width.nil?
          "#{indent + '  '}- Dimensions: #{preferred_width}x#{preferred_height}"
        end
        [
          "#{indent}+ #{name} [#{self.class.name}]",
          dims,
          "#{indent + '  '}- Settings",
          settings.inspect(indent + '    ')
        ].compact.join("\n")
      end
    end
  end
end
