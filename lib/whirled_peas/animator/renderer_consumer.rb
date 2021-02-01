require 'whirled_peas/graphics/renderer'
require 'whirled_peas/utils/ansi'
require 'whirled_peas/device/rendered_frame'

module WhirledPeas
  module Animator
    class RendererConsumer
      def initialize(template_factory, device, width, height)
        @template_factory = template_factory
        @device = device
        @width = width
        @height = height
        @rendered_frames = []
      end

      def add_frameset(frameset)
        frameset.each_frame do |frame, duration, args|
          template = template_factory.build(frame, args)
          strokes = Graphics::Renderer.new(template, width, height).paint
          rendered_frames << Device::RenderedFrame.new(strokes, duration)
        end
      end

      def process
        device.handle_rendered_frames(rendered_frames)
      end

      private

      attr_reader :template_factory, :device, :width, :height, :rendered_frames
    end
  end
end
