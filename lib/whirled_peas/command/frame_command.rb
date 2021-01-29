require_relative 'config_command'

module WhirledPeas
  module Command
    class FrameCommand < ConfigCommand
      private

      attr_reader :frame, :frame_args

      def validate!
        super
        frame = args.shift
        raw_args = args.shift
        if frame.nil?
          @error_text = "#{command_name} requires a frame name"
        else
          @frame = frame
          @frame_args = {}
          return if raw_args.nil?

          require 'json'

          JSON.parse(raw_args || '{}').each do |key, value|
            @frame_args[key.to_sym] = value
          end
        end
      end

      def options_usage
        "#{super} <frame> [args as a JSON string]"
      end
    end
  end
end
