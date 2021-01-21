require 'socket'
require 'json'

module WhirledPeas
  module Frame
    class Producer
      LOGGER_ID = 'PRODUCER'

      def self.produce(event_loop:, logger: NullLogger.new)
        producer = new(event_loop, logger)
        logger.info(LOGGER_ID) { 'Starting' }
        yield producer
        logger.info(LOGGER_ID) { 'Done with yield' }
        producer.send_frame(Frame::EOF)
        logger.info(LOGGER_ID) { 'Exited normally' }
      rescue => e
        producer.send_frame(Frame::TERMINATE)
        logger.warn(LOGGER_ID) { 'Exited with error' }
        logger.error(LOGGER_ID) { e }
        raise
      end

      def initialize(event_loop, logger=NullLogger.new)
        @event_loop = event_loop
        @logger = logger
        @queue = Queue.new
      end

      def send_frame(name, duration: nil, args: {})
        event_loop.enqueue(name: name, duration: duration, args: args)
        logger.debug(LOGGER_ID) { "Sending frame: #{name}" }
      end

      def enqueue_frame(name, duration: nil, args: {})
        queue.push([name, duration, args])
      end

      def flush
        while !queue.empty?
          name, duration, args = queue.pop
          send_frame(name: name, duration: duration, args: args)
        end
      end

      private

      attr_reader :event_loop, :logger
    end
  end
end
