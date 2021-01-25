module WhirledPeas
  module Settings
    class Position
      attr_writer :left, :top

      def left
        @left || 0
      end

      def top
        @top || 0
      end
    end
  end
end
