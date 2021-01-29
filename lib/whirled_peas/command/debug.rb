require_relative 'frame_command'

module WhirledPeas
  module Command
    # Display the template tree for a single frame with the specified arguments.
    class Debug < FrameCommand
      def self.description
        'Print template tree for specified frame'
      end

      def start
        super

        require 'whirled_peas/graphics/debugger'

        template = config.template_factory.build(frame, frame_args)
        puts Graphics::Debugger.new(template).debug
      end
    end
  end
end
