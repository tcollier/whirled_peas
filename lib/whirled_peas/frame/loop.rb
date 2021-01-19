module WhirledPeas
  module Frame
    class Loop
      def initialize(template_builder, refresh_rate_fps)
        @template_builder = template_builder
        @queue = Queue.new
        @refresh_rate_fps = refresh_rate_fps
        @running = false
        @mutex = Mutex.new
      end

      def enqueue(name, duration, args)
        queue.push([name, duration, args])
      end

      def start
        @mutex.synchronize { @running = true }
        screen = UI::Screen.new
        sleep(0.01) while queue.empty?  # Wait for the first event
        remaining_frames = 1
        while remaining_frames > 0
          frame_at = Time.now
          next_frame_at = frame_at + 1.0 / @refresh_rate_fps
          remaining_frames -= 1
          if remaining_frames == 0 && !queue.empty?
            name, remaining_frames, args = queue.pop
            screen.paint(template_builder.build(name, args))
          end
          sleep(next_frame_at - Time.now) if @running
        end
      rescue => e
        puts e.message
        puts e.backtrace.join("\n")
      ensure
        screen.finalize if screen
      end

      def stop
        @mutex.synchronize { @running = false }
      end

      private

      attr_reader :template_builder, :queue, :refresh_rate_fps
    end
    private_constant :Loop
  end
end
