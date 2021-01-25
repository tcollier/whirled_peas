require_relative 'canvas'

module WhirledPeas
  module Graphics
    class Renderer
      def initialize(template, width, height)
        @template = template
        @width = width
        @height = height
      end

      def paint(&block)
        template.paint(Canvas.new(0, 0, width, height, 0, 0), &block)
      end

      private

      attr_reader :template, :width, :height
    end
  end
end
