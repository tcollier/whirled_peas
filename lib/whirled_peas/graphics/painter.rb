module WhirledPeas
  module Graphics
    class Painter
      attr_reader :name, :settings

      def initialize(element, settings, name)
        @element = element
        @settings = settings
        @name = name
      end

      def paint(canvas, &block)
      end

      def dimensions
      end

      private

      attr_reader :element
    end
    private_constant :Painter
  end
end
