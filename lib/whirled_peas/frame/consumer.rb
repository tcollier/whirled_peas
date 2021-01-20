require 'socket'
require 'json'

require_relative 'loop'

module WhirledPeas
  module Frame
    class Consumer
      def initialize(template_factory, refresh_rate)
        @loop = Loop.new(template_factory, refresh_rate)
        @running = false
        @mutex = Mutex.new
      end

      def start(host:, port:)
        @mutex.synchronize { @running = true }
        loop_thread = Thread.new { @loop.start }
        socket = TCPSocket.new(host, port)
        while @running
          line = socket.gets
          if line.nil?
            sleep(0.001)
            next
          end
          args = JSON.parse(line)
          name = args.delete('name')
          if [Frame::EOF, Frame::TERMINATE].include?(name)
            @loop.stop if name == Frame::TERMINATE
            @running = false
          else
            duration = args.delete('duration')
            @loop.enqueue(name, duration, args)
          end
        end
      rescue => e
        @loop.stop
        puts e.message
        puts e.backtrace.join("\n")
      ensure
        loop_thread.join
        socket.close if socket
      end

      def stop
        @mutex.synchronize { @running = false }
      end
    end
  end
end
