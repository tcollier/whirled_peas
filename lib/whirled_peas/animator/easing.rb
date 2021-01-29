module WhirledPeas
  module Animator
    class Easing
      # Implementations of available ease-in functions. Ease-out and ease-in-out can all be
      # derived from ease-in.
      EASING = {
        bezier: proc do |value|
          value /= 2
          2 * value * value * (3 - 2 * value)
        end,
        linear: proc { |value| value },
        parametric: proc do |value|
          value /= 2
          squared = value * value
          2 * squared / (2 * (squared - value) + 1)
        end,
        quadratic: proc do |value|
          value * value
        end
      }

      EFFECTS = %i[in out in_out]

      def initialize(easing=:linear, effect=:in_out)
        unless EASING.key?(easing)
          raise ArgumentError,
                "Invalid easing function: #{easing}, expecting one of #{EASING.keys.join(', ')}"
        end
        unless EFFECTS.include?(effect)
          raise ArgumentError,
                "Invalid effect: #{effect}, expecting one of #{EFFECTS.join(', ')}"
        end
        @easing = easing
        @effect = effect
      end

      def ease(value)
        case effect
        when :in
          ease_in(value)
        when :out
          ease_out(value)
        else
          ease_in_out(value)
        end
      end

      private

      attr_reader :easing, :effect

      # The procs in EASING define the ease-in functions, so we simply need
      # to invoke the function with the given normalized value
      def ease_in(value)
        EASING[easing].call(value)
      end

      # The ease-out function will be the ease-in function rotated 180 degrees.
      def ease_out(value)
        1 - EASING[easing].call(1 - value)
      end

      def ease_in_out(value)
        if value < 0.5
          ease_in(value * 2) / 2
        else
          0.5 + ease_out(2 * value - 1) / 2
        end
      end
    end
  end
end
