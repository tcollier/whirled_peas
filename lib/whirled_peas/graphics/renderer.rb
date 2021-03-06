require_relative 'canvas'
require_relative 'pixel_grid'

module WhirledPeas
  module Graphics
    class Renderer
      def initialize(template, width, height)
        @template = template
        @width = width
        @height = height
      end

      def paint
        # Modify the template's settings so that it fills the entire screen
        template.settings.width = width
        template.settings.height = height
        template.settings.sizing = :border
        template.settings.set_margin(left: 0, top: 0, right: 0, bottom: 0)
        pixel_grid = PixelGrid.new(width, height)
        template.paint(Canvas.new(0, 0, width, height), 0, 0) do |left, top, fstring|
          pixel_grid.add_stroke(left, top, fstring)
        end
        pixel_grid
      end

      private

      attr_reader :template, :width, :height
    end
  end
end
