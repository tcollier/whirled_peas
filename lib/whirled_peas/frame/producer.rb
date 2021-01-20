require 'socket'
require 'json'

module WhirledPeas
  module Frame
    class Producer
      LOGGER_ID = 'PRODUCER'

      def self.start(logger: NullLogger.new, host:, port:, &block)
        server = TCPServer.new(host, port)
        client = server.accept
        logger.info(LOGGER_ID) { "Connected to #{host}:#{port}" }
        producer = new(client, logger)
        yield producer
        logger.info(LOGGER_ID) { 'Exited normally' }
      rescue => e
        producer.terminate
        logger.warn(LOGGER_ID) { 'Exited with error' }
        logger.error(LOGGER_ID) { e.message }
        logger.error(LOGGER_ID) { e.backtrace.join("\n") }
        raise
      ensure
        if client
          logger.info(LOGGER_ID) { 'Closing connection'}
          client.close
        end
      end

      def initialize(client, logger=NullLogger.new)
        @client = client
        @logger = logger
        @queue = Queue.new
      end

      def send(name, duration: nil, args: {})
        client.puts(JSON.generate('name' => name, 'duration' => duration, **args))
        logger.debug(LOGGER_ID) { "Sending frame: #{name}" }
      end

      def enqueue(name, duration: nil, args: {})
        queue.push([name, duration, args])
      end

      def flush
        while !queue.empty?
          name, duration, args = queue.pop
          send(name, duration: duration, args: args)
        end
      end

      def stop
        send(Frame::EOF)
      end

      def terminate
        send(Frame::TERMINATE)
      end

      private

      attr_reader :client, :logger, :queue
    end
  end
end
