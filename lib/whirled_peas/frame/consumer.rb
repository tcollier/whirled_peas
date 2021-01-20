require 'socket'
require 'json'

require_relative 'loop'

module WhirledPeas
  module Frame
    class Consumer
      def initialize(template_factory, refresh_rate_fps)
        @loop = Loop.new(template_factory, refresh_rate_fps)
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
          if name == Frame::TERMINATE
            @running = false
            break
          else
            frames = args.delete('frames')
            @loop.enqueue(name, frames, args)
          end
        end
      rescue => e
        puts e.message
        puts e.backtrace.join("\n")
      ensure
        socket.close if socket
        loop_thread.join
      end

      def stop
        @mutex.synchronize { @running = false }
      end
    end
  end
end
