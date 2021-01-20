require 'socket'
require 'json'

module WhirledPeas
  module Frame
    class Producer
      def self.start(logger: NullLogger.new, host:, port:, &block)
        server = TCPServer.new(host, port)
        client = server.accept
        logger.info('PRODUCER') { "Connected to #{host}:#{port}" }
        producer = new(client, logger)
        yield producer
        logger.info('PRODUCER') { "Exited normally" }
      rescue => e
        logger.warn('PRODUCER') { "Exited with error" }
        logger.error('PRODUCER') { e.message }
        logger.error('PRODUCER') { e.backtrace.join("\n") }
      ensure
        client.close if client
      end

      def initialize(client, logger=NullLogger.new)
        @client = client
        @logger = logger
        @queue = Queue.new
      end

      def send(name, duration: nil, args: {})
        client.puts(JSON.generate('name' => name, 'duration' => duration, **args))
        logger.debug('PRODUCER') { "Sending frame: #{name}" }
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
