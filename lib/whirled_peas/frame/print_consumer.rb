require_relative '../null_logger'

module WhirledPeas
  module Frame
    class PrintConsumer
      LOGGER_ID = 'EVENT LOOP'

      def initialize(logger=NullLogger.new)
        @logger = logger
      end

      def enqueue(name, duration, args)
        if name == Frame::EOF
          puts "EOF frame detected"
        else
          displayed_for = duration ? "#{duration} second(s)" : '1 frame'
          args_str = args.empty? ? '' : " (#{args.inspect})"
          puts "Frame '#{name}' displayed for #{displayed_for}#{args_str}"
        end
      end

      def start
      end

      def stop
      end

      private

      attr_reader :logger
    end
  end
end
