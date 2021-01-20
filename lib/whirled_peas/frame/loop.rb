module WhirledPeas
  module Frame
    class Loop
      def initialize(template_factory, refresh_rate, logger=NullLogger.new)
        @template_factory = template_factory
        @queue = Queue.new
        @refresh_rate = refresh_rate
        @logger = logger
      end

      def enqueue(name, duration, args)
        queue.push([name, duration, args])
      end

      def start
        logger.info('EVENT LOOP') { "Starting" }
        @running = true
        screen = UI::Screen.new
        sleep(0.01) while queue.empty?  # Wait for the first event
        remaining_frames = 1
        template = nil
        while @running && remaining_frames > 0
          frame_at = Time.now
          next_frame_at = frame_at + 1.0 / refresh_rate
          remaining_frames -= 1
          if remaining_frames > 0
            screen.refresh if screen.needs_refresh?
          elsif !queue.empty?
            name, duration, args = queue.pop
            remaining_frames = duration ? duration * refresh_rate : 1
            template = template_factory.build(name, args)
            screen.paint(template)
          end
          sleep(next_frame_at - Time.now)
        end
        logger.info('EVENT LOOP') { "Exiting normally" }
      rescue => e
        logger.warn('EVENT LOOP') { "Exiting with error" }
        logger.error('EVENT LOOP') { e.message }
        logger.error('EVENT LOOP') { e.backtrace.join("\n") }
      ensure
        screen.finalize if screen
      end

      def stop
        logger.info('EVENT LOOP') { "Stopping..." }
        @running = false
      end

      private

      attr_reader :template_factory, :queue, :refresh_rate, :logger
    end
    private_constant :Loop
  end
end
