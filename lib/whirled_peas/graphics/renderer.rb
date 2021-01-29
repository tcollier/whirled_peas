require_relative 'canvas'

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
        strokes = [Utils::Ansi.cursor_visible(false), Utils::Ansi.cursor_pos, Utils::Ansi.clear_down]
        template.paint(Canvas.new(0, 0, width, height), 0, 0) do |left, top, fstring|
          next unless fstring.length > 0
          strokes << Utils::Ansi.cursor_pos(left: left, top: top)
          strokes << fstring
        end
        strokes.join
      end

      private

      attr_reader :template, :width, :height
    end
  end
end
