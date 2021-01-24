require_relative 'element'

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
        @content = val.to_s
      end
    end
  end
end
