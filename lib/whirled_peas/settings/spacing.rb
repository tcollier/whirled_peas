module WhirledPeas
  module Settings
    class Spacing
      attr_writer :left, :top, :right, :bottom

      def left=(value)
        @left = validate!(value)
      end

      def left
        @left || 0
      end

      def top=(value)
        @top = validate!(value)
      end

      def top
        @top || 0
      end

      def right=(value)
        @right = validate!(value)
      end

      def right
        @right || 0
      end

      def bottom=(value)
        @bottom = validate!(value)
      end

      def bottom
        @bottom || 0
      end

      def horiz=(value)
        self.left = self.right = value
      end

      def vert=(value)
        self.top = self.bottom = value
      end

      private

      def validate!(value)
        if value && value < 0
          raise ArgumentError, "Negative values for #{self.class.name.split('::').last.downcase} are not allowed"
        else
          value
        end
      end
    end
    private_constant :Spacing
  end
end
