require 'socket'
require 'json'

require_relative 'event_loop'

module WhirledPeas
  module Frame
    class Consumer
      LOGGER_ID = 'CONSUMER'

      def initialize(template_factory, refresh_rate, logger=NullLogger.new)
        @event_loop = EventLoop.new(template_factory, refresh_rate, logger)
        @logger = logger
        @running = false
        @mutex = Mutex.new
      end

      def start(host:, port:)
        mutex.synchronize { @running = true }
        loop_thread = Thread.new do
          Thread.current.report_on_exception = false
          event_loop.start
        end
        socket = TCPSocket.new(host, port)
        logger.info(LOGGER_ID) { "Connected to #{host}:#{port}" }
        while @running && event_loop.running?
          line = socket.gets
          if line.nil?
            sleep(0.001)
            next
          end
          args = JSON.parse(line)
          name = args.delete('name')
          if [Frame::EOF, Frame::TERMINATE].include?(name)
            logger.info(LOGGER_ID) { "Received #{name} event, stopping..." }
            event_loop.stop if name == Frame::TERMINATE
            @running = false
          else
            duration = args.delete('duration')
            event_loop.enqueue(name, duration, args)
          end
        end
        logger.info(LOGGER_ID) { 'Exited normally' }
        logger.info(LOGGER_ID) { 'Waiting for loop thread to exit' }
        loop_thread.join
      rescue => e
        event_loop.stop if event_loop.running?
        logger.warn(LOGGER_ID) { 'Exited with error' }
        logger.error(LOGGER_ID) { e.message }
        logger.error(LOGGER_ID) { e.backtrace.join("\n") }
        raise
      ensure
        logger.info(LOGGER_ID) { 'Closing socket' }
        socket.close if socket
      end

      def stop
        logger.info(LOGGER_ID) { 'Stopping...' }
        mutex.synchronize { @running = false }
      end

      private

      attr_reader :event_loop, :logger, :mutex
    end
  end
end
