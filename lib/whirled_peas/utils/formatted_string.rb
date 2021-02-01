require_relative 'ansi'

module WhirledPeas
  module Utils
    class FormattedString
      def self.blank
        new('')
      end

      attr_reader :formatting

      def initialize(raw, formatting=nil)
        @raw = raw
        @formatting = [*formatting]
      end

      def length
        raw.length
      end

      def each_char(&block)
        raw.chars.each(&block)
      end

      def blank?
        raw.empty?
      end

      def hash
        [raw, formatting].hash
      end

      def ==(other)
        case other
        when self.class
          hash == other.hash
        when String
          formatting.empty? && raw == other
        else
          false
        end
      end

      def to_s
        if raw.empty? || formatting.length == 0
          raw
        else
          start_formatting = formatting.map { |code| Ansi.esc_seq(code) }.join
          "#{start_formatting}#{raw}#{Ansi.clear}"
        end
      end

      def inspect
        if raw.empty? || formatting.length == 0
          raw.inspect
        else
          "<#{formatting.join(', ')}>#{raw}<0>".inspect
        end
      end

      private

      attr_reader :raw
    end
  end
end
