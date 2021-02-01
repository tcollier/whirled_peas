require_relative 'easing'
require_relative 'frameset'

module WhirledPeas
  module Animator
    class Producer
      def self.produce(consumer)
        producer = new(consumer)
        yield producer
        consumer.process
      end

      def initialize(consumer)
        @consumer = consumer
      end

      def add_frame(name, duration:, args: {})
        frameset(duration) do |fs|
          fs.add_frame(name, args: args)
        end
      end

      def frameset(duration, easing: :linear, effect: :in_out, &block)
        fs = Frameset.new(duration, easing, effect)
        yield fs
        consumer.add_frameset(fs)
      end

      private

      attr_reader :consumer
    end
  end
end
