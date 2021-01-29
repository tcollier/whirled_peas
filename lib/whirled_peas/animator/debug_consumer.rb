module WhirledPeas
  module Animator
    class DebugConsumer
      def add_frameset(frameset)
        require 'json'

        frameset.each_frame do |frame, args|
          puts [frame, *(JSON.generate(args) unless args.empty?)].join(' ')
        end
      end

      def process
        # no op
      end
    end
  end
end
