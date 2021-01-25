module WhirledPeas
  module Graphics
    class Painter
      attr_reader :name, :settings

      def initialize(name, settings)
        @settings = settings
        @name = name
      end

      def paint(canvas, &block)
      end

      def dimensions
      end
    end
    private_constant :Painter
  end
end
