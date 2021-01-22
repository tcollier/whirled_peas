require 'socket'
require 'json'

require_relative '../null_logger'

module WhirledPeas
  module Frame
    class Producer
      LOGGER_ID = 'PRODUCER'

      # Manages the EventLoop lifecycle and yields a Producer to send frames to the
      # EventLoop
      def self.produce(event_loop, logger=NullLogger.new)
        producer = new(event_loop, logger)
        event_loop_thread = Thread.new do
          Thread.current.report_on_exception = false
          event_loop.start
        end
        yield producer
        producer.send_frame(Frame::EOF)
        producer.flush
      rescue => e
        event_loop.stop if event_loop
        logger.warn(LOGGER_ID) { 'Exited with error' }
        logger.error(LOGGER_ID) { e }
        raise
      ensure
        event_loop_thread.join if event_loop_thread
      end

      def initialize(event_loop, logger=NullLogger.new)
        @event_loop = event_loop
        @logger = logger
        @queue = Queue.new
      end

      # Buffer a frame to be played for the given duration. `#flush` must be called
      # for frames to get pushed to the EventLoop.
      #
      # @param name [String] name of frame, which is passed to #build of the
      #   TemplateFactory
      # @param duration [Float|Integer] duration in seconds the frame should be,
      #   displayed (default is nil, which results in a duration of a single refresh
      #   cycle)
      # @param args [Hash] key/value pair of arguments, which is passed to #build of
      #   the TemplateFactory
      def send_frame(name, duration: nil, args: {})
        queue.push([name, duration, args])
      end

      # Send any buffered frames to the EventLoop
      def flush
        event_loop.enqueue(*queue.pop) while !queue.empty?
      end

      private

      attr_reader :event_loop, :logger, :queue
    end
  end
end
