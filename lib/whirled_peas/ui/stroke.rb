module WhirledPeas
  module UI
    class Stroke
      EMPTY = Stroke.new

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
  end
end
