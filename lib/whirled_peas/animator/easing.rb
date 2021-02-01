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

      INVERSE_MAX_ITERATIONS = 10
      INVERSE_DELTA = 0.0001
      INVERSE_EPSILON = 0.00001

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

      def invert(target)
        ease_fn = case effect
        when :in
          proc { |v| ease_in(v) }
        when :out
          proc { |v| ease_out(v) }
        else
          proc { |v| ease_in_out(v) }
        end

        # Use Newton's method(!!) to find the inverse values of the easing function for the
        # specified target. Make an initial guess that is equal to the target and see how
        # far off the eased value is from the target. If we are close enough (as dictated by
        # INVERSE_EPSILON constant), then we return our guess. If we aren't close enough, then
        # find the slope of the eased line (approximated with a small step of INVERSE_DELTA
        # along the x-axis). The intersection of the slope and target will give us the value
        # of our next guess.
        #
        # Since most easing functions only vary slightly from the identity line (y = x), we
        # can typically get the eased guess within epsilon of the target in a few iterations,
        # however only iterate at most INVERSE_MAX_ITERATIONS times.
        #
        #         ┃                     ......
        #         ┃                  ...
        # target -┃------------+  ...
        #         ┃          /.|..
        #         ┃      ../.  |
        #         ┃   ...  |   |
        #         ┃...     |   |
        #         ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━
        #                  |   |
        #              guess   next guess
        #
        # IMPORTANT: This method only works well for monotonic easing functions

        # Pick the target as the first guess. For targets of 0 and 1 (and 0.5 for ease_in_out),
        # this guess will be the exact value that yields the target. For other values, the
        # eased guess will generally be close to the target.
        guess = target
        INVERSE_MAX_ITERATIONS.times do |i|
          eased_guess = ease_fn.call(guess)
          error = eased_guess - target
          break if error.abs < INVERSE_EPSILON
          next_eased_guess = ease_fn.call(guess + INVERSE_DELTA)
          delta_eased = next_eased_guess - eased_guess
          guess -= INVERSE_DELTA * error / delta_eased
        end
        guess
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

      # Ease in/ease out
      #
      # @see https://www.youtube.com/watch?v=5WPbqYoz9HA
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
