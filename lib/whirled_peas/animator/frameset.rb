require_relative 'easing'
require_relative 'frame'

module WhirledPeas
  module Animator
    class Frameset
      def initialize(frame_slots, easing, effect)
        @frame_slots = frame_slots
        @easing = Easing.new(easing, effect)
        @frames = []
      end

      def add_frame(name, args={})
        frames << [name, args]
      end

      # Yield each frame in an "eased" order
      def each_frame(&block)
        frame_slots.times do |i|
          input = i.to_f / (frame_slots - 1)
          eased_value = @easing.ease(input)
          index = (eased_value * (frames.length - 1)).floor
          yield *frames[index]
        end
      end

      private

      attr_reader :frame_slots, :easing, :frames
    end
    private_constant :Frameset
  end
end
