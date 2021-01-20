require_relative 'stroke'

module WhirledPeas
  module UI
    class Canvas
      attr_reader :left, :top, :width, :height

      def initialize(left, top, width, height)
        @left = left
        @top = top
        @width = width
        @height = height
      end

      def stroke(left, top, chars)
        if left >= self.left + self.width || left + chars.length <= self.left
          Stroke::EMPTY
        elsif top < self.top || top >= self.top + self.height
          Stroke::EMPTY
        else
          if left < self.left
            chars = chars[self.left - left..-1]
            left = self.left
          end
          num_chars = [self.left + self.width, left + chars.length].min - left
          Stroke.new(left, top, Ansi.first(chars, num_chars))
        end
      end

      def inspect
        "Canvas(left=#{left}, top=#{top}, width=#{width}, height=#{height})"
      end
    end
  end
end
