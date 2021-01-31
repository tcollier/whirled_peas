## Application

The application is code to be visualized that integrates with Whirled Peas by providing the signature below

```ruby
# Start the application and pass frame events to the producer to be rendered
# by the UI
#
# @param producer [Producer] frame producer that sends events to the UI
def start(producer)
  # application code here
end
```

The producer provides the following methods

```ruby
# Add a frame to be displayed
#
# @param name [String] (required) application defined name for the frame. The
#    template factory will be provided this name
# @param duration [Number] (optional) time in seconds this frame should be
#   displayed for (defaults to 1 frame)
# @param args [Hash<Symbol, Object>] (optional) key/value pairs to send as
#   arguments to the template factory
def add_frame(name, duration:, args:)
end

# Create and yield a frameset instance that allows applications to add multiple
# frames to play over the given duration. Adding frames to the yielded frameset
# will result in playback that is eased by the given `easing` and `effect`
# arguments (default is `:linear` easing)
#
# @param duration [Number] (required) total duration for which all frames in
#   frameset will be displayed
# @param easing [Symbol] (optional) easing function to be used to transition
#   through all frames (defaults to `:linear`)
# @param effect [Symbol] (optional) how to apply the easing function (defaults
#   to `:in_out`, also available are `:in` and `:out`)
# @yield [Frameset] instance that provides `#add_frame(name, args:)`
def frameset(duration, easing:, effect:, &block)
end
```

See the [easing documentation](easing.md) for more details on the various easing functions.

A frameset instance provides one method

```ruby
# Add a frame to be displayed, the duration will be determine by the number of
# frames in the frameset along with the duration and easing of the frameset
#
# @param name [String] (required) application defined name for the frame. The
#   template factory will be provided this name
# @param args [Hash<Symbol, Object>] (optional) key/value pairs to send as
#   arguments to the template factory
def add_frame(name, args:)
end
```

**IMPORTANT**: the keys in the `args` hash must be symbols!

### Example

Simple application that loads a set of numbers and looks for a pair that adds up to 1,000

```ruby
class Application
  def start(producer)
    numbers = File.readlines('/path/to/numbers.txt').map(&:to_i)
    producer.add_frame('load-numbers', duration: 3, args: { numbers: numbers })
    numbers.sort!
    producer.add_frame('sort-numbers', duration: 3, args: { numbers: numbers })
    low = 0
    high = numbers.length - 1
    while low < high
      sum = numbers[low] + numbers[high]
      if sum == 1000
        producer.add_frame('found-pair', duration: 5, args: { low: low, high: high, sum: sum })
        return
      elsif sum < 1000
        producer.add_frame('too-low', args: { low: low, high: high, sum: sum })
        low += 1
      else
        producer.add_frame('too-high', args: { low: low, high: high, sum: sum })
        high -= 1
      end
    end
    producer.add_frame('no-solution', duration: 5)
  end
end
```
