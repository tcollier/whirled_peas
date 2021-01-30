module WhirledPeas
  module Settings
    class Position
      attr_reader :left, :top, :right, :bottom

      def left=(value)
        @right = nil
        @left = value
      end

      def top=(value)
        @bottom = nil
        @top = value
      end

      def right=(value)
        @left = nil
        @right = value
      end

      def bottom=(value)
        @top = nil
        @bottom = value
      end
    end
  end
end
