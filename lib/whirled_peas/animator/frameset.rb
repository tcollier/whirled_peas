require_relative 'easing'
require_relative 'frame'

module WhirledPeas
  module Animator
    class Frameset
      def initialize(duration, easing, effect)
        @duration = duration
        @easing = Easing.new(easing, effect)
        @frames = []
      end

      def add_frame(name, args: {})
        frames << [name, args]
      end

      # Yield each frame in an "eased" order
      def each_frame(&block)
        return if frames.length == 0
        if frames.length == 1
          frame, args = frames[0]
          yield frame, duration, args
        else
          frames.each.with_index do |(frame, args), index|
            curr_ease = @easing.invert(index.to_f / frames.length)
            next_ease = @easing.invert((index + 1).to_f / frames.length)
            yield frame, duration * (next_ease - curr_ease), args
          end
        end
      end

      private

      attr_reader :duration, :easing, :frames
    end
    private_constant :Frameset
  end
end
