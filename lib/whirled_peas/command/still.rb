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

        require 'whirled_peas/frame/event_loop'
        require 'whirled_peas/frame/producer'

        logger = build_logger
        consumer = Frame::EventLoop.new(
          config.template_factory,
          logger: logger
        )
        Frame::Producer.produce(consumer, logger) do |producer|
          producer.send_frame(frame, duration: 5, args: frame_args)
        end
      end
    end
  end
end
