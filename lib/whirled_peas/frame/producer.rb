require 'socket'
require 'json'

require_relative '../null_logger'

module WhirledPeas
  module Frame
    class Producer
      LOGGER_ID = 'PRODUCER'

      # Manages the EventLoop lifecycle and yields a Producer to send frames to the
      # EventLoop
      def self.produce(consumer, logger=NullLogger.new)
        producer = new(consumer, logger)
        consumer_thread = Thread.new do
          Thread.current.report_on_exception = false
          consumer.start
        end
        yield producer
        producer.send_frame(Frame::EOF)
        producer.flush
      rescue => e
        consumer.stop if consumer
        logger.warn(LOGGER_ID) { 'Exited with error' }
        logger.error(LOGGER_ID) { e }
        raise
      ensure
        consumer_thread.join if consumer_thread
      end

      def initialize(consumer, logger=NullLogger.new)
        @consumer = consumer
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
        consumer.enqueue(*queue.pop) while !queue.empty?
      end

      private

      attr_reader :consumer, :logger, :queue
    end
  end
end
