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
        # Modify the template's settings so that it fills the entire screen
        template.settings.width = width
        template.settings.height = height
        template.settings.sizing = :border
        template.settings.set_margin(left: 0, top: 0, right: 0, bottom: 0)
        template.paint(Canvas.new(0, 0, width, height, 0, 0), &block)
      end

      private

      attr_reader :template, :width, :height
    end
  end
end
