require 'socket'
require 'json'

require_relative 'loop'

module WhirledPeas
  module Frame
    class Consumer
      def initialize(template_factory, refresh_rate, logger=NullLogger.new)
        @loop = Loop.new(template_factory, refresh_rate, logger)
        @logger = logger
        @running = false
        @mutex = Mutex.new
      end

      def start(host:, port:)
        mutex.synchronize { @running = true }
        loop_thread = Thread.new { loop.start }
        socket = TCPSocket.new(host, port)
        logger.info('CONSUMER') { "Connected to #{host}:#{port}" }
        while @running
          line = socket.gets
          if line.nil?
            sleep(0.001)
            next
          end
          args = JSON.parse(line)
          name = args.delete('name')
          if [Frame::EOF, Frame::TERMINATE].include?(name)
            logger.info('CONSUMER') { "Received #{name} event, stopping..." }
            loop.stop if name == Frame::TERMINATE
            @running = false
          else
            duration = args.delete('duration')
            loop.enqueue(name, duration, args)
          end
        end
        logger.info('CONSUMER') { "Exited normally" }
      rescue => e
        logger.warn('CONSUMER') { "Exited with error" }
        logger.error('CONSUMER') { e.message }
        logger.error('CONSUMER') { e.backtrace.join("\n") }
        loop.stop
      ensure
        logger.info('CONSUMER') { "Waiting for loop thread to exit" }
        loop_thread.join
        logger.info('CONSUMER') { "Closing socket" }
        socket.close if socket
      end

      def stop
        logger.info('CONSUMER') { "Stopping..." }
        mutex.synchronize { @running = false }
      end

      private

      attr_reader :loop, :logger, :mutex
    end
  end
end
