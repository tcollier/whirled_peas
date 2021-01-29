require_relative 'easing'
require_relative 'frameset'

module WhirledPeas
  module Animator
    class Producer
      def self.produce(consumer, refresh_rate)
        producer = new(consumer, refresh_rate)
        yield producer
        consumer.process
      end

      def initialize(consumer, refresh_rate)
        @consumer = consumer
        @refresh_rate = refresh_rate
      end

      def add_frame(name, duration: nil, args: {})
        frameset(duration || 1 / refresh_rate) do |fs|
          fs.add_frame(name, args: args)
        end
      end

      def frameset(duration, easing: :linear, effect: :in_out, &block)
        fs = Frameset.new((duration * refresh_rate).round, easing, effect)
        yield fs
        consumer.add_frameset(fs)
      end

      private

      attr_reader :consumer, :refresh_rate
    end
  end
end
