require 'whirled_peas/device/rendered_frame'

require_relative 'frame_command'

module WhirledPeas
  module Command
    # Display a still frame with the specified arguments.
    class Still < FrameCommand
      def self.description
        'Show the specified still frame'
      end

      def start
        super

        require 'whirled_peas/device/screen'
        require 'whirled_peas/graphics/renderer'
        require 'whirled_peas/utils/ansi'

        Utils::Ansi.with_screen do |width, height|
          strokes = Graphics::Renderer.new(
            WhirledPeas.config.template_factory.build(frame, frame_args),
            width,
            height
          ).paint
          Device::Screen.new.handle_rendered_frames(
            [Device::RenderedFrame.new(strokes, 0)]
          )
        end
      end
    end
  end
end
