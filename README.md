# WhirledPeas

Visualize your code's execution with Whirled Peas!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'whirled_peas'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install whirled_peas

## Usage

```ruby
require 'whirled_peas'

class TemplateFactory
  def build(frame, args)
    WhirledPeas.template do |body|
      body.add_box do |_, settings|
        settings.underline = true
        "Hello #{args['name']}"
      end
      # ...
    end
  end
end

class Driver
  def start(producer)
    producer.send('starting', args: { 'name' => 'World' })
    # ...
  end
end

WhirledPeas.start(Driver.new, TemplateFactory.new)
```

A Whirled Peas application consists of two pieces

1. The driver, which emits lightweight frame events
1. The template factory, which builds templates to convert frame events from the driver into terminal graphics

### Driver

The driver is the application code to be visualized. This is typically a lightweight wrapper around an existing application that conforms to the signature below.

```ruby
# Start the application and pass frame events to the producer to be rendered by the UI
#
# @param producer [Producer] frame producer that sends events to the UI
def start(producer)
  # application code here
end
```

The producer provides a single method

```ruby
# Send frame events to the UI
#
# @param name [String] application defined name for the frame. The template factory will be provided this name
# @param duration [Number] time in seconds this frame should be displayed for (defaults to 1 frame)
# @param args [Hash] key value pairs to send as arguments to the template factory, these values will be
#   serialized/deserialized
def send(name, duration:, args:)
  # implementation
end
```

#### Example

Simple application that loads a set of numbers and looks for a pair that adds up to 1,000

```ruby
class Driver
  def start(producer)
    numbers = File.readlines('/path/to/numbers.txt').map(&:to_i)
    producer.send('load-numbers', duration: 3, args: { numbers: numbers })
    numbers.sort!
    producer.send('sort-numbers', duration: 3, args: { numbers: numbers })
    low = 0
    high = numbers.length - 1
    while low < high
      sum = numbers[low] + numbers[high]
      if sum == 1000
        producer.send('found-pair', duration: 5, args: { low: low, high: high, sum: sum })
        return
      elsif sum < 1000
        producer.send('too-low', args: { low: low, high: high, sum: sum })
        low += 1
      else
        producer.send('too-high', args: { low: low, high: high, sum: sum })
        high -= 1
      end
    end
    producer.send('no-solution', duration: 5)
  end
end
```

### Template Factory

To render the frame events sent by the driver, the application requires a template factory. This factory will be called for each frame event, with the frame name and the arguments supplied by the driver. A template factory can be a simple ruby class and thus can maintain state. Whirled Peas provides a few basic building blocks to make simple, yet elegant terminal-based UIs.

#### Building Blocks

A template is created with `WhirledPeas.template`, which yields a `Template` object and `TemplateSettings`. This template object is a `ComposableElement`, which allows for attaching child elements and setting layout options. `GridElement` and `BoxElement` are two other composable elements and `TextElement` is a simple element that can hold a text/number value and has layout options, but cannot have any child elements.

A `ComposableElement` provides the following methods to add child elements

- `add_box` - yields a `ComposableElement` and a `BoxSettings`, which will be added to the parent's children
- `add_grid` - yields a `ComposableElement` and a `GridSettings`, which will be added to the parent's children
- `add_text` - yields `nil` and a `TextSettings`, which will be added to the parent's children

E.g.

```ruby
WhirledPeas.template do |template, template_settings|
  template_settings.bg_color = :blue
  template.add_grid do |grid, grid_settings|
    grid_settings.num_cols = 10
    100.times do |i|
      grid.add_text { i.to_s }
    end
  end
end
```

The above template can also be broken down into more manageable methods, e.g.

```ruby
def number_grid(grid, settings)
  settings.num_cols = 10
  100.times do |i|
    grid.add_text { i.to_s }
  end
end

WhirledPeas.template do |template, settings|
  settings.bg_color = :blue
  template.add_grid(&method(:number_grid))
end
```

Additionally, if no child element is explicitly added to a `GridElement`, but the block returns an array of strings or numbers, those will be converted to `TextElements` and added as children to the `GridElement`. For example, these are identical ways to create a grid of strings

```ruby
template.add_grid do |g|
  100.times do |i|
    g.add_text { i.to_s }
  end
end

template.add_grid do |g|
  100.times.map(&:to_s)
end
```

Similarly, if no child element is explicilty added to a `BoxElement`, but the block returns a string or number, that value will be converted to a `TextElement` and added as a child. For example, these are identical ways to create a box with string content

```ruby
template.add_box do |b|
  b.add_text { "Hello!" }
end

template.add_box do |b|
  "Hello!"
end
```

#### Settings

Each element type has an associated settings type, which provide a custom set of options to format the output. Parent settings may be merged into child settings (assuming the child supports those settings)
The available settigs are

| Setting       | Description                                                        | Default | Availability                      | Merged? |
| ------------- | ------------------------------------------------------------------ | ------- | --------------------------------- | ------- |
| `align`       | Justifies the text (allowed values: `:left`, `:center`, `:right`)  | `:left` | `Box`, `Grid`, `Text`             | Yes     |
| `auto_margin` | Evenly distribute side margin (overrides left/right in `margin`)   | `false` | `Box`, `Grid`                     | Yes     |
| `bg_color`    | Background color (see [Colors](#colors))                           |         | `Box`, `Grid`, `Template`, `Text` | Yes     |
| `bold`        | `true` makes the font bold                                         | `false` | `Box`, `Grid`, `Template`, `Text` | Yes     |
| `border`      | Set the border for the lements                                     | none    | `Box`, `Grid`,                    | Yes     |
| `color`       | Foreground text color (see [Colors](#colors))                      |         | `Box`, `Grid`, `Template`, `Text` | Yes     |
| `flow`        | Flow to display child elements (see [Display Flow](#display-flow)) | `:l2r`  | `Box`                             | Yes     |
| `margin`      | Set the (left, top, right, bottom) margin of the element           | `0`     | `Box`, `Grid`                     | Yes     |
| `padding`     | Set the (left, top, right, bottom) padding of the element          | `0`     | `Box`, `Grid`                     | Yes     |
| `transpose`   | Display grid elements top-to-bottom, then left-to-right            | `false` | `Grid`                            | No      |
| `underline`   | `true` underlines the font                                         | `false` | `Box`, `Grid`, `Template`, `Text` | Yes     |
| `width`       | Override the calculated with of an element                         |         | `Box`, `Grid`, `Text`             | No      |

##### Margin and Padding

Margin and padding settings allow for setting the spacing on each of the 4 sides of the element independently. The set these values, use

- `set_margin(left:, top:, right:, bottom:)`
- `set_padding(left:, top:, right:, bottom:)`

Any argument value not provided will result in that value being 0.

##### Border

The border settings consist of 6 boolean values (border are either width 1 or not shown), the 4 obvious values (`left`, `top`, `right`, and `bottom`) along with 2 other values for inner borders (`inner_horiz` and `inner_vert`) in a grid. A border also has a foreground color (defaults to `:white`) and a style. The background color is determined by the `bg_color` of the element. Border values can be set with

- `set_border(left:, top:, right:, bottom:, inner_horiz:, inner_vert:, color:, style:)`

Available border styles are

- `:bold` (default)

```
┏━━┳━━┓
┃  ┃  ┃
┣━━╋━━┫
┃  ┃  ┃
┗━━┻━━┛
```

- `:double`

```
╔══╦══╗
║  ║  ║
╠══╬══╣
║  ║  ║
╚══╩══╝
```

- `:soft`

```
╭──┬──╮
│  │  │
├──┼──┤
│  │  │
╰──┴──╯
```

##### Display Flow

Child elements can flow in one of 4 directions

- `:l2r` left-to-right

```
[child 1] [child 2] ... [child N]
```

- `:r2l` right-to-left

```
[child N] [child N - 1] ... [child 1]
```

- `:t2b` top-to-bottom

```
[child 1]
[child 2]
 ...
[child N]
```

- `:b2t` bottom-to-top

```
[child N]
[child N - 1]
 ...
[child 1]
```

##### Colors

Below is the list of available colors (for both foreground and background)

- `:black`
- `:blue`
- `:cyan`
- `:gray`
- `:green`
- `:magenta`
- `:red`
- `:white`
- `:yellow`

Many of these also have a "bright" option:

- `:bright_blue`
- `:bright_cyan`
- `:bright_green`
- `:bright_magenta`
- `:bright_red`
- `:bright_yellow`

### Example

```ruby
class TemplateFactory
  def build(frame, args)
    set_state(frame, args)
    WhirledPeas.template do |t|
      t.add_box(&method(:body))
    end
  end

  private

  def set_state(frame, args)
    @frame = frame
    @numbers = args.key?('numbers') ? args['numbers'] || []
    @sum = args['sum'] if args.key?('sum')
    @low = args['low'] if args.key?('low')
    @high = args['high'] if args.key?('high')
  end

  def title(_elem, settings)
    settings.underline = true
    "Pair Finder"
  end

  def sum(_elem, settings)
    settings.color = @frame == 'found-pair' ? :green : :red
    @sum ? "Sum: #{@sum}" : 'N/A'
  end

  def number_grid(elem, settings)
    settings.full_border
    @numbers.each.with_index do |num, index|
      g.add_text do |_, settings|
        settings.bg_color = (@low == index || @high == index) ? :cyan : :white
        num.to_s
      end
    end
  end

  def body(elem, settings)
    settings.flow = :l2r
    settings.auto_margin = true

    elem.add_box(&method(:title))
    elem.add_box(&method(:sum))
    elem.add_grid(&method(:number_grid))
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/whirled_peas. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/whirled_peas/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WhirledPeas project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/whirled_peas/blob/master/CODE_OF_CONDUCT.md).
