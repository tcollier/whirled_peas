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
          rendered = Graphics::Renderer.new(
            WhirledPeas.config.template_factory.build(frame, frame_args),
            width,
            height
          ).paint
          Device::Screen.new(10000).handle_renders([rendered])
        end
      end
    end
  end
end
