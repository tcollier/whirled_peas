require 'whirled_peas/graphics/renderer'
require 'whirled_peas/utils/ansi'

module WhirledPeas
  module Animator
    class RendererConsumer
      def initialize(template_factory, device, width, height)
        @template_factory = template_factory
        @device = device
        @width = width
        @height = height
        @renders = []
      end

      def add_frameset(frameset)
        frameset.each_frame do |frame, args|
          template = template_factory.build(frame, args)
          renders << Graphics::Renderer.new(template, width, height).paint
        end
      end

      def process
        device.handle_renders(renders)
      end

      private

      attr_reader :template_factory, :device, :width, :height, :renders
    end
  end
end
