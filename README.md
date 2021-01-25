[![Build Status](https://travis-ci.com/tcollier/whirled_peas.svg?branch=main)](https://travis-ci.com/tcollier/whirled_peas)

# WhirledPeas

```
                ██╗   ██╗██╗███████╗██╗   ██╗ █████╗ ██╗     ██╗███████╗███████╗
                ██║   ██║██║██╔════╝██║   ██║██╔══██╗██║     ██║╚══███╔╝██╔════╝
                ██║   ██║██║███████╗██║   ██║███████║██║     ██║  ███╔╝ █████╗
                ╚██╗ ██╔╝██║╚════██║██║   ██║██╔══██║██║     ██║ ███╔╝  ██╔══╝
                 ╚████╔╝ ██║███████║╚██████╔╝██║  ██║███████╗██║███████╗███████╗
                  ╚═══╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝╚══════╝╚══════╝

                                   your code's execution with

    ██╗    ██╗██╗  ██╗██╗██████╗ ██╗     ███████╗██████╗    ██████╗ ███████╗ █████╗ ███████╗
    ██║    ██║██║  ██║██║██╔══██╗██║     ██╔════╝██╔══██╗   ██╔══██╗██╔════╝██╔══██╗██╔════╝
    ██║ █╗ ██║███████║██║██████╔╝██║     █████╗  ██║  ██║   ██████╔╝█████╗  ███████║███████╗
    ██║███╗██║██╔══██║██║██╔══██╗██║     ██╔══╝  ██║  ██║   ██╔═══╝ ██╔══╝  ██╔══██║╚════██║
    ╚███╔███╔╝██║  ██║██║██║  ██║███████╗███████╗██████╔╝   ██║     ███████╗██║  ██║███████║
     ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚═════╝    ╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝
```

Easily create terminal-based graphics to visual the execution of your code. Whirled Peas offers templating inspired by HTML and CSS and provides a lightweight tie-in for your code to produce visual animations with these templates.

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

A Whirled Peas application consists of the following pieces

- The driver (required) - the code that is to be visualized, it emits lightweight frame events through a producer
- The main template factory (required) - builds templates to convert frame events from the driver into terminal graphics
- A loading screen template factory (optional) - builds templates to display while content is loading

These pieces are configured as following

```ruby
# visualize.rb
require 'whirled_peas'

class TemplateFactory
  def build(frame, args)
    WhirledPeas.template do |composer|
      composer.add_box('Title') do |_, settings|
        settings.underline = true
        "Hello #{args[:name]}"
      end
      # ...
    end
  end
end

class Driver
  def start(producer)
    producer.send_frame('starting', args: { name: 'World' })
    # ...
  end
end

WhirledPeas.configure do |config|
  config.driver = Driver.new
  config.template_factory = TemplateFactory.new
end
```

Then the visualizer is started on the command line with

```
$ whirled_peas start visualize.rb
```

The optional loading screen can be configured like

```ruby
class LoadingTemplateFactory
  def build
    WhirledPeas.template do |composer|
      composer.add_box('Loading') do |_, settings|
        settings.set_margin(top: 15)
        settings.align = :center
        settings.full_border(color: :blue, style: :double)
        "Loading..."
      end
    end
  end
end

WhirledPeas.configure do |config|
  # ...
  config.loading_template_factory = LoadingTemplateFactory.new
end
```

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
# @param args [Hash<Symbol, Object>] key value pairs to send as arguments to the template factory
def send_frame(name, duration:, args:)
  # implementation
end
```

**IMPORTANT**: the keys in the `args` hash must be symbols!

#### Example

Simple application that loads a set of numbers and looks for a pair that adds up to 1,000

```ruby
class Driver
  def start(producer)
    numbers = File.readlines('/path/to/numbers.txt').map(&:to_i)
    producer.send_frame('load-numbers', duration: 3, args: { numbers: numbers })
    numbers.sort!
    producer.send_frame('sort-numbers', duration: 3, args: { numbers: numbers })
    low = 0
    high = numbers.length - 1
    while low < high
      sum = numbers[low] + numbers[high]
      if sum == 1000
        producer.send_frame('found-pair', duration: 5, args: { low: low, high: high, sum: sum })
        return
      elsif sum < 1000
        producer.send_frame('too-low', args: { low: low, high: high, sum: sum })
        low += 1
      else
        producer.send_frame('too-high', args: { low: low, high: high, sum: sum })
        high -= 1
      end
    end
    producer.send_frame('no-solution', duration: 5)
  end
end
```

### Template Factory

To render the frame events sent by the driver, the application requires a template factory. This factory will be called for each frame event, with the frame name and the arguments supplied by the driver. A template factory can be an instance of ruby class and thus can maintain state. Whirled Peas provides a few basic building blocks to make simple, yet elegant terminal-based UIs.

#### Loading Template Factory

`WhirledPeas.configure` takes an optional template factory to build a loading screen. This instance must implement `#build` (taking no arguments). The template returned by that method will be painted while the event loop is waiting for frames. The factory method will be called once per refresh cycle, so it's possible to implement animation.

#### Building Blocks

A template is created with `WhirledPeas.template`, which yields a `Composer` object for a `Box` and `BoxSettings`. The composer allows for attaching child elements and the settings for setting layout options.

A `Composer` provides the following methods to add child elements, each of these takes an optional string argument that is set as the name of the element (which can be useful when debugging).

- `add_box` - yields a `Composer` for a `Box` and a `BoxSettings`, which will be added to the parent's children
- `add_grid` - yields a `Composer` for a `Grid` and a `GridSettings`, which will be added to the parent's children
- `add_text` - yields `nil` and a `TextSettings`, which will be added to the parent's children

E.g.

```ruby
WhirledPeas.template do |composer, settings|
  settings.bg_color = :blue
  composer.add_grid do |composer, settings|
    settings.num_cols = 10
    100.times do |i|
      composer.add_text { i }
    end
  end
end
```

The above template can also be broken down into more manageable methods, e.g.

```ruby
def number_grid(_composer, settings)
  settings.num_cols = 10
  100.times.map(&:itself)
end

WhirledPeas.template do |composer, settings|
  settings.bg_color = :blue
  composer.add_grid(&method(:number_grid))
end
```

Additionally, if no child element is explicitly added to a `Grid`, but the block returns an array of strings or numbers, those will be converted to `Text` elements and added as children to the `Grid`. For example, these are identical ways to create a grid of strings

```ruby
template.add_grid do |composer|
  100.times do |i|
    composer.add_text { i }
  end
end

template.add_grid do
  100.times.map(&:itself)
end
```

Similarly, if no child element is explicilty added to a `Box`, but the block returns a string or number, that value will be converted to a `Text` and added as a child. For example, these are identical ways to create a box with string content

```ruby
template.add_box do |composer|
  composer.add_text { "Hello!" }
end

template.add_box do
  "Hello!"
end
```

#### Settings

Each element type has an associated settings type, which provide a custom set of options to format the output. Child settings will inherit from the parent, where applicable
The available settigs are

| Setting      | Description                                                                     | Default | Availability          | Inherited            |
| ------------ | ------------------------------------------------------------------------------- | ------- | --------------------- | -------------------- |
| `align`      | Justifies the content (allowed values: `:left`, `:center`, `:right`)            | `:left` | `Box`, `Grid`         | Yes                  |
| `bg_color`   | Background color (see [Colors](#colors))                                        |         | `Box`, `Grid`, `Text` | Yes                  |
| `bold`       | `true` makes the font bold                                                      | `false` | `Box`, `Grid`, `Text` | Yes                  |
| `border`     | Set the border for the lements                                                  | none    | `Box`, `Grid`,        | Only style and color |
| `color`      | Foreground text color (see [Colors](#colors))                                   |         | `Box`, `Grid`, `Text` | Yes                  |
| `flow`       | Flow to display child elements (see [Display Flow](#display-flow))              | `:l2r`  | `Box`, `Grid`         | Yes                  |
| `height`     | Override the calculated height of an element's content area                     |         | `Box`, `Grid`         | No                   |
| `margin`     | Set the (left, top, right, bottom) margin of the element                        | `0`     | `Box`, `Grid`         | No                   |
| `num_cols`   | Number of columns in the grid (must be set!)                                    |         | `Grid`                | No                   |
| `padding`    | Set the (left, top, right, bottom) padding of the element                       | `0`     | `Box`, `Grid`         | No                   |
| `position`   | Set the (left, top) position of the element relative to parent content area     | `0`     | `Box`, `Grid`         | No                   |
| `title_font` | Font used for "large" text (see [Large Text](#large-text), ignores `underline`) |         | `Text`                | No                   |
| `underline`  | `true` underlines the font                                                      | `false` | `Box`, `Grid`, `Text` | Yes                  |
| `width`      | Override the calculated width of an element's content area                      |         | `Box`, `Grid`         | No                   |

##### Position

Position settings dictate the relative position from where the painter would have preferred to place the container. Negative numbers move the container left/up and positive numbers move it right/down. To set these values, use

- `set_position(left:, top:)`

##### Margin

Margin settings dictate the spacing on the outside (i.e. outside of the border) of each of the 4 sides of the container independently. To set these values, use

- `set_margin(left:, top:, right:, bottom:)`

Note: values cannot be negative

##### Padding

Padding settings dictate the spacing on the inside (i.e. inside of the border) of each of the 4 sides of the container independently. To set these values, use

- `set_padding(left:, top:, right:, bottom:)`

Note: values cannot be negative

##### Border

The border settings consist of 6 boolean values (border are either width 1 or not shown), the 4 obvious values (`left`, `top`, `right`, and `bottom`) along with 2 other values for inner borders (`inner_horiz` and `inner_vert`) in a grid. A border also has a foreground color (defaults to `:white`) and a style. The background color is determined by the `bg_color` of the element. Border values can be set with

- `set_border(left:, top:, right:, bottom:, inner_horiz:, inner_vert:, color:, style:)`
- `full_border(style:, color:)`

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

##### Large Text

The `title_font` setting for `Text`s converts the standard terminal font into a large block font. The available fonts vary from system to system. Every system will have a `:default` font available, this font could look like

```
██████╗ ███████╗███████╗ █████╗ ██╗   ██╗██╗     ████████╗
██╔══██╗██╔════╝██╔════╝██╔══██╗██║   ██║██║     ╚══██╔══╝
██║  ██║█████╗  █████╗  ███████║██║   ██║██║        ██║
██║  ██║██╔══╝  ██╔══╝  ██╔══██║██║   ██║██║        ██║
██████╔╝███████╗██║     ██║  ██║╚██████╔╝███████╗   ██║
╚═════╝ ╚══════╝╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝
```

To print out a list of all available fonts as well as sample text in that font, run

```
$ whirled_peas title_fonts
```

Note: when using a title font with WhirledPeas for the first time on a system, the gem loads all fonts to check which ones are available. This can be a slow process and may cause a noticeable delay when running a visualization. Running the command above will cache the results and thus when a WhirledPeas visualization is run, there will be no lag from loading fonts.

### Example

```ruby
class TemplateFactory
  def build(frame, args)
    set_state(frame, args)
    WhirledPeas.template do |composer, settings|
      settings.flow = :l2r
      settings.align = :center

      composer.add_box('Title', &method(:title))
      composer.add_box('Sum', &method(:sum))
      composer.add_grid('NumberGrid', &method(:number_grid))
    end
  end

  private

  def set_state(frame, args)
    @frame = frame
    @numbers = args.key?(:numbers) ? args[:numbers] || []
    @sum = args[:sum] if args.key?(:sum)
    @low = args[:low] if args.key?(:low)
    @high = args[:high] if args.key?(:high)
  end

  def title(_composer, settings)
    settings.underline = true
    "Pair Finder"
  end

  def sum(_composer, settings)
    settings.color = @frame == 'found-pair' ? :green : :red
    @sum ? "Sum: #{@sum}" : 'N/A'
  end

  def number_grid(composer, settings)
    settings.full_border
    @numbers.each.with_index do |num, index|
      composer.add_text do |_, settings|
        settings.bg_color = (@low == index || @high == index) ? :cyan : :white
        num
      end
    end
  end
end
```

### Debugging

The `whirled_peas` executable provides some commands that are helpful for debugging.

#### list_frames

List the frames sent by the driver

```
$ whirled_peas <config file> list_frames
Frame 'start' displayed for 5 second(s)
Frame 'move' displayed for 1 frame ({:direction=>'N'})
...
EOF frame detected
```

#### play_frame

Displays a single frame for several seconds

```
$ whirled_peas <config file> play_frame move '{"direction":"N"}'
```

Adding the `--template` flag will result in printing out debug information for the template, e.g.

```
$ whirled_peas <config file> play_frame move '{"direction":"N"}' --template
+ TEMPLATE [WhirledPeas::Graphics::BoxPainter]
  - Settings
    WhirledPeas::Settings::BoxSettings
      <default>
  - Children
    + TitleContainer [WhirledPeas::Graphics::BoxPainter]
...
```

#### loading

Displays the configured loading screen for several seconds

```
$ whirled_peas <config file> loading
```

Adding the `--template` flag will result in just printing out the loading template's debug information, e.g.

```
$ whirled_peas <config file> loading --template
+ TEMPLATE [WhirledPeas::Graphics::BoxPainter]
  - Settings
    WhirledPeas::Settings::BoxSettings
      <default>
  - Children
    + TitleContainer [WhirledPeas::Graphics::BoxPainter]
...
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Testing

In addition to standard RSpec tests, WhirledPeas has custom tests for rendered templates. These files live in `screen_test/rendered`. Each ruby file is expected to define a class named `TemplateFactory` that responds to `#build(name, args)` returning a template (the standard template factory role). Each file should also be accompanied by a `.frame` file with the same base name. This file will contain the output of the rendered screen and is considered the correct output when running tests.

Note: viewing `.frame` files with `cat` works better than most other text editors.

The following rake tasks are provided to interact with the screen tests

- `screen_test` runs all screen tests in the `screen_test/rendered` directory
- `screen_test:debug[path/to/file.rb]` print the rendered template debug tree
- `screen_test:run[path/to/file.rb]` runs a single screen test
- `screen_test:save[path/to/file.rb]` saves the output generated by the template in the `.frame` file, overwriting any existing file
- `screen_test:view[path/to/file.rb]` views the output generated by the template
- `screen_test:update_all[path/to/file.rb]` interactively step through each pending or failed screen test to compare/set the expected output

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/whirled_peas. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/whirled_peas/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WhirledPeas project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/whirled_peas/blob/master/CODE_OF_CONDUCT.md).
