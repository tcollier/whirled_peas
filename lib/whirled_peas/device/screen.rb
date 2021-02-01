require 'highline'

module WhirledPeas
  module Device
    class Screen
      def initialize(output: STDOUT)
        @output = output
      end

      def handle_rendered_frames(rendered_frames)
        next_frame_at = nil
        rendered_frames.each do |rendered_frame|
          if next_frame_at.nil?
            next_frame_at = Time.now + rendered_frame.duration
          else
            next_frame_at += rendered_frame.duration
            next if next_frame_at < Time.now
          end
          output.print(rendered_frame.strokes)
          output.flush
          sleep([0, next_frame_at - Time.now].max)
        end
      end

      private

      attr_reader :output
    end
  end
end
