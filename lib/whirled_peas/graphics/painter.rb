module WhirledPeas
  module Graphics
    # Abstract base Painter class. Given a canvas and start coordinates (left, top), a painter
    # is responsible for generating the "strokes" that display the element.
    class Painter
      attr_reader :name, :settings

      def initialize(name, settings)
        @settings = settings
        @name = name
      end

      # Paint the element onto the canvas by yielding strokes to the block. A stroke is composed
      # of a left, top, and chars. E.g.
      #
      #   yield 10, 3, 'Hello World!'
      #
      # paints the string "Hello World!" in the 10th column from the left, 3rd row down.
      def paint(canvas, left, top, &block)
      end

      # Return a dimension object that provider the `outer_width` and `outer_height` of the
      # element being painted.
      def dimensions
      end

      def inspect
        "#{self.class.name.split('::').last}(name=#{name.inspect})"
      end
    end
    private_constant :Painter
  end
end
