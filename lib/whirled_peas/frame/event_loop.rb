require_relative '../null_logger'
require_relative '../ui/screen'

module WhirledPeas
  module Frame
    class EventLoop
      LOGGER_ID = 'EVENT LOOP'

      def initialize(template_factory, loading_template_factory, refresh_rate, logger=NullLogger.new)
        @template_factory = template_factory
        @loading_template_factory = loading_template_factory
        @queue = Queue.new
        @frame_duration = 1.0 / refresh_rate
        @logger = logger
      end

      def enqueue(name, duration, args)
        # If duration is nil, set it to the duration of a single frame
        queue.push([name, duration || frame_duration, args])
      end

      def running?
        @running
      end

      def start
        screen = UI::Screen.new
        wait_for_content(screen)
        play_content(screen)
      rescue
        logger.warn(LOGGER_ID) { 'Exiting with error' }
        raise
      ensure
        # We may have exited due to an EOF or a raised exception, set state so that
        # instance reflects actual state.
        @running = false
        screen.finalize if screen
      end

      def stop
        logger.info(LOGGER_ID) { 'Stopping...' }
        @running = false
      end

      private

      attr_reader :template_factory, :loading_template_factory, :queue, :frame_duration, :logger

      def wait_for_content(screen)
        if loading_template_factory
          play_loading_screen(screen)
        else
          sleep(frame_duration) while queue.empty?
        end
      end

      def play_loading_screen(screen)
        while queue.empty?
          screen.paint(loading_template_factory.build)
          sleep(frame_duration)
        end
      end

      def play_content(screen)
        @running = true
        template = nil
        frame_until = Time.new(0)  # Tell the loop to immediately pick up a new frame
        while running?
          frame_start = Time.now
          next_frame_at = frame_start + frame_duration
          if frame_until > frame_start
            # While we're still displaying the previous frame, refresh the screen
            screen.refresh
          elsif !queue.empty?
            name, duration, args = queue.pop
            if name == Frame::EOF
              @running = false
            else
              frame_until = frame_start + duration
              template = template_factory.build(name, args)
              screen.paint(template)
            end
          else
            wait_for_content(screen)
          end
          sleep([0, next_frame_at - Time.now].max)
        end
      end
    end
  end
end
