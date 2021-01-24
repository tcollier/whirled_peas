require 'whirled_peas/null_logger'
require 'whirled_peas/graphics/screen'

require_relative 'consumer'

module WhirledPeas
  module Frame
    class EventLoop < Consumer
      DEFAULT_REFRESH_RATE = 30

      LOGGER_ID = 'EVENT LOOP'

      def initialize(
        template_factory,
        loading_template_factory=nil,
        refresh_rate: DEFAULT_REFRESH_RATE,
        logger: NullLogger.new,
        screen: Graphics::Screen.new
      )
        @template_factory = template_factory
        @loading_template_factory = loading_template_factory
        @queue = Queue.new
        @frame_duration = 1.0 / refresh_rate
        @logger = logger
        @screen = screen
      end

      def enqueue(name, duration, args)
        # If duration is nil, set it to the duration of a single frame
        queue.push([name, duration || frame_duration, args])
      end

      def start
        super
        wait_for_content
        play_content
      rescue
        self.running = false
        logger.warn(LOGGER_ID) { 'Exiting with error' }
        raise
      ensure
        screen.finalize
      end

      private

      attr_reader :template_factory, :loading_template_factory, :queue, :frame_duration, :logger, :screen

      def wait_for_content
        if loading_template_factory
          play_loading_screen
        else
          sleep(frame_duration) while queue.empty?
        end
      end

      def play_loading_screen
        while queue.empty?
          screen.paint(loading_template_factory.build)
          sleep(frame_duration)
        end
      end

      def play_content
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
            if name == EOF
              self.running = false
            else
              frame_until = frame_start + duration
              template = template_factory.build(name, args)
              screen.paint(template)
            end
          else
            wait_for_content
          end
          sleep([0, next_frame_at - Time.now].max)
        end
      end
    end
  end
end
