module WhirledPeas
  module Settings
    class Spacing
      attr_writer :left, :top, :right, :bottom

      def left
        @left || 0
      end

      def top
        @top || 0
      end

      def right
        @right || 0
      end

      def bottom
        @bottom || 0
      end
    end
    private_constant :Spacing
  end
end
