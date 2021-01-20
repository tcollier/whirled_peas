require 'socket'
require 'json'

module WhirledPeas
  module Frame
    class Producer
      def self.start(host:, port:, &block)
        server = TCPServer.new(host, port)
        client = server.accept
        producer = new(client)
        yield producer
      rescue => e
        puts e.message
        puts e.backtrace.join("\n")
      ensure
        client.close if client
      end

      def initialize(client)
        @client = client
        @queue = Queue.new
      end

      def send(name, duration: nil, args: {})
        client.puts(JSON.generate('name' => name, 'duration' => duration, **args))
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
        send(Frame::TERMINATE)
      end

      private

      attr_reader :client, :queue
    end
  end
end
