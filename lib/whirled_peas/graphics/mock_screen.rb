require_relative 'renderer'

module WhirledPeas
  module Graphics
    class MockScreen
      def initialize(width, height)
        @width = width
        @height = height
      end

      def paint(template)
        Renderer.new(template, width, height).paint { }
      end

      def refresh
      end

      def finalize
      end

      private

      attr_reader :width, :height
    end
  end
end
