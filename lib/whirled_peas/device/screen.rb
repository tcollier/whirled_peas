require 'highline'

module WhirledPeas
  module Device
    class Screen
      def initialize(refresh_rate, output: STDOUT)
        @refresh_rate = refresh_rate
        @output = output
      end

      def handle_renders(renders)
        renders.each do |strokes|
          frame_at = Time.now
          output.print(strokes)
          output.flush
          next_frame_at = frame_at + 1.0 / refresh_rate
          sleep([0, next_frame_at - Time.now].max)
        end
      end

      private

      attr_reader :refresh_rate, :output
    end
  end
end
