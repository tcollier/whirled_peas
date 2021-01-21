require_relative 'ansi'

module WhirledPeas
  module UI
    # Canvas represent the area of the screen a painter can paint on.
    class Canvas
      # A Stroke is a single line, formatted string of characters that is painted at
      # a given position on a Canvas. This class is not meant to be instantiated
      # directly. Instead, use Canvas#stroke to create a new Stroke.
      class Stroke
        attr_reader :left, :top, :chars

        def initialize(left, top, chars)
          @left = left
          @top = top
          @chars = chars
        end

        def hash
          [left, top, chars].hash
        end

        def ==(other)
          other.is_a?(self.class) && self.hash == other.hash
        end

        def inspect
          "Stroke(left=#{left}, top=#{top}, chars=#{chars})"
        end

        alias_method :eq?, :==
      end
      private_constant :Stroke

      EMPTY_STROKE = Stroke.new(nil, nil, nil)

      attr_reader :left, :top, :width, :height

      def initialize(left, top, width, height)
        @left = left
        @top = top
        @width = width
        @height = height
      end

      # Return a new Stroke instance, verifying only characters within the canvas
      # are included in the stroke.
      def stroke(left, top, chars)
        if left >= self.left + self.width || left + chars.length <= self.left
          EMPTY_STROKE
        elsif top < self.top || top >= self.top + self.height
          EMPTY_STROKE
        else
          if left < self.left
            chars = chars[self.left - left..-1]
            left = self.left
          end
          num_chars = [self.left + self.width, left + chars.length].min - left
          Stroke.new(left, top, Ansi.substring(chars, 0, num_chars))
        end
      end

      def inspect
        "Canvas(left=#{left}, top=#{top}, width=#{width}, height=#{height})"
      end
    end
  end
end
