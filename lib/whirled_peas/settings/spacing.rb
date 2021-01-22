require 'json'

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

      def inspect
        vals = {}
        vals[:left] = @left if @left
        vals[:top] = @top if @top
        vals[:right] = @right if @right
        vals[:bottom] = @bottom if @bottom
        JSON.generate(vals) if vals.any?
      end
    end
    private_constant :Spacing

    class Padding < Spacing
    end

    class Margin < Spacing
    end
  end
end
