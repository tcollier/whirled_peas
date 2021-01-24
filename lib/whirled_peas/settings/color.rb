require 'whirled_peas/utils/ansi'

module WhirledPeas
  module Settings
    # An abstract class that encapsulates colors for a specific use case
    class Color
      # Validate the `color` argument is either (1) nil, (2) a valid Color constant in
      # this class or (3) a symbol that maps to valid Color constant. E.g. if there
      # is a RED constant in an implementing class, then :red or :bright_red are
      # valid values for `color`
      #
      # @param color [Color|Symbol]
      # @return [Color|Symbol] the value passed in if valid, otherwise an ArgumentError
      #   is raised.
      def self.validate!(color)
        return unless color
        if color.is_a?(Symbol)
          error_message = "Unsupported #{self.name.split('::').last}: #{color.inspect}"
          match = color.to_s.match(/^(bright_)?(\w+)$/)
          begin
            color = self.const_get(match[2].upcase)
            raise ArgumentError, error_message unless color.is_a?(Color)
            if match[1]
              raise ArgumentError, error_message if color.bright?
              color.bright
            else
              color
            end
          rescue NameError
            raise ArgumentError, error_message
          end
        else
          color
        end
      end

      def initialize(code, bright=false)
        @code = code
        @bright = bright
      end

      def bright?
        @bright
      end

      def bright
        bright? ? self : self.class.new(@code + Utils::Ansi::BRIGHT_OFFSET, true)
      end

      def hash
        [@code, @bright].hash
      end

      def ==(other)
        other.is_a?(self.class) && self.hash == other.hash
      end
      alias_method :eq?, :==

      def to_s
        @code.to_s
      end

      def inspect
        "#{self.class.name.split('::').last}(code=#{@code}, bright=#{@bright})"
      end
    end
    private_constant :Color
  end
end
