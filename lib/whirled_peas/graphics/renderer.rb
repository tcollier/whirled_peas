require 'whirled_peas/template/box_element'
require 'whirled_peas/template/container'
require 'whirled_peas/template/grid_element'
require 'whirled_peas/template/text_element'

require_relative 'box_painter'
require_relative 'canvas'
require_relative 'grid_painter'
require_relative 'text_painter'

module WhirledPeas
  module Graphics
    class Renderer
      PAINTERS = {
        Template::BoxElement => BoxPainter,
        Template::GridElement => GridPainter,
        Template::TextElement => TextPainter
      }
      def initialize(template, width, height)
        @template = template
        @width = width
        @height = height
      end

      def paint(&block)
        painter.paint(Canvas.new(0, 0, width, height, 0, 0), &block)
      end

      def painter
        build(template)
      end

      private

      attr_reader :template, :width, :height

      def build(element)
        unless PAINTERS.key?(element.class)
          raise ArgumentError, "Unable to render #{element.class}"
        end
        painter = PAINTERS[element.class].new(element, element.settings, element.name)
        if element.is_a?(Template::Container)
          element.each_child { |child| painter.add_child(build(child)) }
        end
        painter
      end
    end
  end
end
