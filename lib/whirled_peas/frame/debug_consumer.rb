require 'whirled_peas/null_logger'

require_relative 'consumer'

module WhirledPeas
  module Frame
    class DebugConsumer < Consumer
      LOGGER_ID = 'PRINTER'

      def initialize(output=STDOUT, logger=NullLogger.new)
        @output = output
        @logger = logger
      end

      def enqueue(name, duration, args)
        if name == EOF
          output.puts "EOF frame detected"
        else
          displayed_for = duration ? "#{duration} second(s)" : '1 frame'
          args_str = args.empty? ? '' : " '#{JSON.generate(args)}'"
          output.puts "Frame '#{name}' displayed for #{displayed_for}#{args_str}"
        end
      end

      private

      attr_reader :output, :logger
    end
  end
end
