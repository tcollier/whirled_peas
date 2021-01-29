[![Build Status](https://travis-ci.com/tcollier/whirled_peas.svg?branch=main)](https://travis-ci.com/tcollier/whirled_peas)

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

Easily create terminal-based graphics to visualize the execution of your code. Whirled Peas offers templating inspired by HTML and CSS and provides a lightweight tie-in for your code to produce visual animations with these templates.

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

- The application (required) - the code that is to be visualized, it emits lightweight frame events through a producer
- The main template factory (required) - builds templates to convert frame events from the application into terminal graphics

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

class Application
  def start(producer)
    producer.add_frame('starting', args: { name: 'World' })
    # ...
  end
end

WhirledPeas.configure do |config|
  config.application = Application.new
  config.template_factory = TemplateFactory.new
end
```

Then the visualizer is started on the command line with

```
$ whirled_peas play visualize.rb
```

### Application

The application is code to be visualized that integrates with Whirled Peas by providing the signature below

```ruby
# Start the application and pass frame events to the producer to be rendered by the UI
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
# @param name [String] application defined name for the frame. The template factory will be provided this name
# @param duration [Number] time in seconds this frame should be displayed for (defaults to 1 frame)
# @param args [Hash<Symbol, Object>] key value pairs to send as arguments to the template factory
def add_frame(name, duration:, args:)
end

# Create and yield a frameset instance that allows applications to add multiple frames to play over the
# given duration. Adding frames to the yielded frameset will result in playback that is eased by the
# gvien `easing` and `effect` arguments (default is `:linear` easing)
def frameset(duration, easing:, effect:, &block)
end
```

A frameset instance provides one method

```ruby
# Add a frame to be displayed, the duration will be determine by the number of frames in the frameset along
# with the duration and easing of the frameset
#
# @param name [String] application defined name for the frame. The template factory will be provided this name
# @param args [Hash<Symbol, Object>] key value pairs to send as arguments to the template factory
def add_frame(name, args:)
end
```

**IMPORTANT**: the keys in the `args` hash must be symbols!

#### Example

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

### Template Factory

To render the frame events sent by the application, the application requires a template factory. This factory will be called for each frame event, with the frame name and the arguments supplied by the application. A template factory can be an instance of ruby class and thus can maintain state. Whirled Peas provides a few basic building blocks to make simple, yet elegant terminal-based UIs.

#### Building Blocks

A template is created with `WhirledPeas.template`, which yields a `Composer` object for a `Box` and `BoxSettings`. The composer allows for attaching child elements and the settings for setting layout options. The following attributes of the template's settings will be overridden before it is rendered to ensure that it fills the screen exactly

- `margin` - all margin will be set to 0
- `width` - will be set to the screen's width
- `height` - will be set to the screen's height
- `sizing` - will be set `:border` to ensure the entire box fits on the screen and fills it entirely.

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

| Setting      | Description                                                                      | Default    | Availability          | Inherited            |
| ------------ | -------------------------------------------------------------------------------- | ---------- | --------------------- | -------------------- |
| `align`      | Justifies the content in the horizontal direction                                | `:left`    | `Box`, `Grid`         | No                   |
| `bg_color`   | Background color (see [Colors](#colors))                                         |            | `Box`, `Grid`, `Text` | Yes                  |
| `bold`       | `true` makes the font bold                                                       | `false`    | `Box`, `Grid`, `Text` | Yes                  |
| `border`     | Set the border for the lements                                                   | none       | `Box`, `Grid`,        | Only style and color |
| `color`      | Foreground text color (see [Colors](#colors))                                    |            | `Box`, `Grid`, `Text` | Yes                  |
| `flow`       | Flow to display child elements (see [Display Flow](#display-flow))               | `:l2r`     | `Box`, `Grid`         | No                   |
| `height`     | Override the calculated height of an element's content area                      |            | `Box`, `Grid`         | No                   |
| `margin`     | Set the (left, top, right, bottom) margin of the element                         | `0`        | `Box`, `Grid`         | No                   |
| `num_cols`   | Number of columns in the grid (must be set!)                                     |            | `Grid`                | No                   |
| `padding`    | Set the (left, top, right, bottom) padding of the element                        | `0`        | `Box`, `Grid`         | No                   |
| `position`   | Set the (left, top) position of the element relative to parent content area      | `0`        | `Box`, `Grid`         | No                   |
| `scrollbar`  | Display a scroll bar for vertical or horizontal scrolling                        |            | `Box`                 | No                   |
| `sizing`     | Sizing model (`:content` or `:border`) used in conjunction with `width`/`height` | `:content` | `Box`                 | No                   |
| `title_font` | Font used for "large" text (see [Large Text](#large-text), ignores `underline`)  |            | `Text`                | No                   |
| `underline`  | `true` underlines the font                                                       | `false`    | `Box`, `Grid`, `Text` | Yes                  |
| `width`      | Override the calculated width of an element's content area                       |            | `Box`, `Grid`         | No                   |
| `valign`     | Justifies the content in the vertical direction                                  | `:top`     | `Box`, `Grid`         | No                   |

##### Alignment

The `align` setting takes one of several values

- `:left` - align content starting at the leftmost edge of the container's content area

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃[child 1][child 2][child 3]            ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

- `:right` - align content starting at the rightmost edge of the container's content area

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃            [child 1][child 2][child 3]┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

- `:center` - align content starting in the horizontal center of the container's content area

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃      [child 1][child 2][child 3]      ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

- `:between` - distribute children so there is equal space between children no space outside of the children

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃[child 1]      [child 2]      [child 3]┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

- `:around` - distribute children so that they have equal spacing around them, space between two children is twice the space between an edge and a child.

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  [child 1]    [child 2]    [child 3]  ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

- `:evenly` - distribute children so there is even spacing between any two children (or space to the edge)

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃   [child 1]   [child 2]   [child 3]   ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

The `valign` setting takes one of several values

- `:top` - align content starting at the top of the container's content area

```
┏━━━━━━━━━┓
┃[child 1]┃
┃[child 2]┃
┃[child 3]┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┗━━━━━━━━━┛
```

- `:bottom` - align content starting at the bottom of the container's content area

```
┏━━━━━━━━━┓
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃[child 1]┃
┃[child 2]┃
┃[child 3]┃
┗━━━━━━━━━┛
```

- `:middle` - align content starting in the vertical middle of the container's content area

```
┏━━━━━━━━━┓
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃[child 1]┃
┃[child 2]┃
┃[child 3]┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┗━━━━━━━━━┛
```

- `:between` - distribute children so there is equal space between children no space outside of the children

```
┏━━━━━━━━━┓
┃[child 1]┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃[child 2]┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃[child 3]┃
┗━━━━━━━━━┛
```

- `:around` - distribute children so that they have equal spacing around them, space between two children is twice the space between an edge and a child.

```
┏━━━━━━━━━┓
┃         ┃
┃         ┃
┃[child 1]┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃[child 2]┃
┃         ┃
┃         ┃
┃         ┃
┃         ┃
┃[child 3]┃
┃         ┃
┃         ┃
┗━━━━━━━━━┛
```

- `:evenly` - distribute children so there is even spacing between any two children (or space to the edge)

```
┏━━━━━━━━━┓
┃         ┃
┃         ┃
┃         ┃
┃[child 1]┃
┃         ┃
┃         ┃
┃         ┃
┃[child 2]┃
┃         ┃
┃         ┃
┃         ┃
┃[child 3]┃
┃         ┃
┃         ┃
┃         ┃
┗━━━━━━━━━┛
```

##### Position

Position settings dictate the relative position from where the painter would have preferred to place the container. Negative numbers move the container left/up and positive numbers move it right/down. To set these values, use

- `set_position(left:, top:)`

##### Sizing Model

The sizing model determines how to interpret the `width` and `height` settings. The default sizing model is `:content`, which sets the width and height of the cotent area, whereas `:border` sets the width and height of the element inlcuding the padding and border and scroll bars.

###### Examples

In the examples below, the `~` character represents padding and would not be displayed in the acutal rendered screen.

```ruby
settings.width = 10
settings.height = 3
settings.set_padding(left: 3, top: 1, right: 3, bottom: 1)
settings.full_border

## Content sizing
settings.sizing = :content

# Results in the box
#
#   ┏━━━━━━━━━━━━━━━━┓
#   ┃~~~~~~~~~~~~~~~~┃
#   ┃~~~1234567890~~~┃
#   ┃~~~1234567890~~~┃
#   ┃~~~1234567890~~~┃
#   ┃~~~~~~~~~~~~~~~~┃
#   ┗━━━━━━━━━━━━━━━━┛

## Border sizing
settings.sizing = :border

# Results in the box
#
#   ┏━━━━━━━━┓
#   ┃~~~12~~~┃
#   ┗━━━━━━━━┛
```

Notice that a box rendered with `:border` sizing would fit exactly in the content area of a box with the same `width` and `height` that is rendered with `:content` sizing. For containers with no padding and no border, the resulting size is the same for either sizing model.

##### Margin

Margin settings dictate the spacing on the outside (i.e. outside of the border) of each of the 4 sides of the container independently. To set these values, use

- `set_margin(left:, top:, right:, bottom:, horiz:, vert:)` - set any combination of margin (note: setting `horiz` and `left`/`right` or setting `vert` and `top`/`bottom` is not allowed)
- `margin.left=(value)` - set left margin
- `margin.top=(value)` - set top margin
- `margin.right=(value)` - set right margin
- `margin.bottom=(value)` - set bottom margin
- `margin.horiz=(value)` - set left and right margin to the same value
- `margin.vert=(value)` - set top and bottom margin to the same value

Note: values cannot be negative

##### Padding

Padding settings dictate the spacing on the inside (i.e. inside of the border) of each of the 4 sides of the container independently. To set these values, use

- `set_padding(left:, top:, right:, bottom:, horiz:, vert:)` - set any combination of padding (note: setting `horiz` and `left`/`right` or setting `vert` and `top`/`bottom` is not allowed)
- `padding.left=(value)` - set left padding
- `padding.top=(value)` - set top padding
- `padding.right=(value)` - set right padding
- `padding.bottom=(value)` - set bottom padding
- `padding.horiz=(value)` - set left and right padding to the same value
- `padding.vert=(value)` - set top and bottom padding to the same value

Note: values cannot be negative

##### Scrollbar

Scroll settings dictate whether the scrollbar will be shown when child content is larger the the container's viewport. A scrollbar adds a unit to the dimensions of a container (as opposed to overwriting the leftmost/bottommost padding)

- `set_scrollbar(horiz:, vert:)` - set both scrollbar settings
- `scrollbar.horiz=(flag)` - show/hide the horizontal scrollbar
- `scrollbar.vert=(flag)` - show/hide the vertical scrollbar

Note: there is a know bug with scrollbars and `center`/`right` alignments. Using `left` alignment is the supported workaround

##### Border

The border settings consist of 6 boolean values (border are either width 1 or not shown), the 4 obvious values (`left`, `top`, `right`, and `bottom`) along with 2 other values for inner borders (`inner_horiz` and `inner_vert`) in a grid. A border also has a foreground color (defaults to `:white`) and a style. The background color is determined by the `bg_color` of the element. Border values can be set with

- `set_border(left:, top:, right:, bottom:, inner_horiz:, inner_vert:, color:, style:)` - set any combination of border settings
- `full_border(style:, color:)` - set all borders to true and optionally set the style or color
- `border.left=(flag)` - show/hide left border
- `border.top=(flag)` - show/hide top border
- `border.right=(flag)` - show/hide right border
- `border.bottom=(flag)` - show/hide bottom border
- `border.inner_horiz=(flag)` - show/hide inner horizontal border (dividing grid rows)
- `border.inner_vert=(flag)` - show/hide inner vertical border (dividing grid columns)
- `border.color=(text_color)` - set the border color
- `border.style=(style)` - set the border style

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
# In a Box
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃[child 1] [child 2] ... [child N]┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# In a Grid
┏━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┓
┃[child 1]┃[child 2]┃[child 3]┃
┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
┃[chiid 4]┃[child 5]┃         ┃
┗━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┛
```

- `:r2l` right-to-left

```
# In a Box
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃[child N] [child N - 1] ... [child 1]┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# In a Grid
┏━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┓
┃[child 3]┃[child 2]┃[child 1]┃
┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
┃         ┃[chiid 5]┃[child 4]┃
┗━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┛
```

- `:t2b` top-to-bottom

```
# In a Box
┏━━━━━━━━━┓
┃[child 1]┃
┃[child 2]┃
┃ ...     ┃
┃[child N]┃
┗━━━━━━━━━┛

# In a Grid
┏━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┓
┃[child 1]┃[child 3]┃[child 5]┃
┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
┃[child 2]┃[child 4]┃         ┃
┗━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┛
```

- `:b2t` bottom-to-top

```
# In a Box
┏━━━━━━━━━━━━━┓
┃[child N]    ┃
┃[child N - 1]┃
┃ ...         ┃
┃[child 1]    ┃
┗━━━━━━━━━━━━━┛

# In a Grid
┏━━━━━━━━━┳━━━━━━━━━┳━━━━━━━━━┓
┃[child 2]┃[child 4]┃         ┃
┣━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫
┃[child 1]┃[child 3]┃[child 5]┃
┗━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┛
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

#### Easing

The play duration of a frame within a frameset is determined by the easing function and effect along with the frames relative position within the frameset. The three effects are

- `:in` - apply easing only to the start of the frameset
- `:out` - apply easing only to the end of the frameset
- `:in_out` - apply easing to the start and end of the frameset

The available easing functions are

- `:bezier`

```
# bezier (in)
┃                                                         ▄▀
┃                                                      ▄▄▀
┃                                                    ▄▀
┃                                                 ▄▀▀
┃                                              ▄▄▀
┃                                           ▄▄▀
┃                                        ▄▄▀
┃                                      ▄▀
┃                                  ▄▄▀▀
┃                               ▄▄▀
┃                            ▄▀▀
┃                        ▄▄▀▀
┃                   ▄▄▀▀▀
┃             ▄▄▄▀▀▀
┃▄▄▄▄▄▄▄▄▄▄▀▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# bezier (out)
┃                                               ▄▄▄▀▀▀▀▀▀▀▀▀
┃                                         ▄▄▄▀▀▀
┃                                    ▄▄▄▀▀
┃                                ▄▄▀▀
┃                             ▄▄▀
┃                          ▄▀▀
┃                      ▄▄▀▀
┃                    ▄▀
┃                 ▄▀▀
┃              ▄▀▀
┃           ▄▀▀
┃        ▄▄▀
┃      ▄▀
┃   ▄▀▀
┃▄▄▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# bezier (in_out)
┃                                                  ▄▄▄▀▀▀▀▀▀
┃                                              ▄▄▀▀
┃                                           ▄▀▀
┃                                        ▄▀▀
┃                                     ▄▀▀
┃                                  ▄▀▀
┃                               ▄▄▀
┃                             ▄▀
┃                          ▄▀▀
┃                       ▄▄▀
┃                    ▄▄▀
┃                 ▄▄▀
┃              ▄▄▀
┃          ▄▄▀▀
┃▄▄▄▄▄▄▄▀▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

`:linear`

```
# linear (in)
┃                                                        ▄▄▀
┃                                                    ▄▄▀▀
┃                                                ▄▄▀▀
┃                                            ▄▄▀▀
┃                                        ▄▄▀▀
┃                                    ▄▄▀▀
┃                                ▄▄▀▀
┃                            ▄▄▀▀
┃                        ▄▄▀▀
┃                    ▄▄▀▀
┃                ▄▄▀▀
┃            ▄▄▀▀
┃        ▄▄▀▀
┃    ▄▄▀▀
┃▄▄▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# linear (out)
┃                                                        ▄▄▀
┃                                                    ▄▄▀▀
┃                                                ▄▄▀▀
┃                                            ▄▄▀▀
┃                                        ▄▄▀▀
┃                                    ▄▄▀▀
┃                                ▄▄▀▀
┃                            ▄▄▀▀
┃                        ▄▄▀▀
┃                    ▄▄▀▀
┃                ▄▄▀▀
┃            ▄▄▀▀
┃        ▄▄▀▀
┃    ▄▄▀▀
┃▄▄▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# linear (in_out)
┃                                                        ▄▄▀
┃                                                    ▄▄▀▀
┃                                                ▄▄▀▀
┃                                            ▄▄▀▀
┃                                        ▄▄▀▀
┃                                    ▄▄▀▀
┃                                ▄▄▀▀
┃                            ▄▄▀▀
┃                        ▄▄▀▀
┃                    ▄▄▀▀
┃                ▄▄▀▀
┃            ▄▄▀▀
┃        ▄▄▀▀
┃    ▄▄▀▀
┃▄▄▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

`:parametric`

```
# parametric (in)
┃                                                          ▄
┃                                                        ▄▀
┃                                                      ▄▀
┃                                                   ▄▄▀
┃                                                 ▄▀
┃                                               ▄▀
┃                                             ▄▀
┃                                          ▄▄▀
┃                                        ▄▀
┃                                     ▄▀▀
┃                                  ▄▀▀
┃                              ▄▄▀▀
┃                         ▄▄▄▀▀
┃                   ▄▄▄▄▀▀
┃▄▄▄▄▄▄▄▄▄▄▄▄▄▄▀▀▀▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# parametric (out)
┃                                         ▄▄▄▄▄▀▀▀▀▀▀▀▀▀▀▀▀▀
┃                                   ▄▄▀▀▀▀
┃                              ▄▄▀▀▀
┃                          ▄▄▀▀
┃                       ▄▄▀
┃                    ▄▄▀
┃                  ▄▀
┃               ▄▀▀
┃             ▄▀
┃           ▄▀
┃         ▄▀
┃      ▄▀▀
┃    ▄▀
┃  ▄▀
┃▄▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# parametric (in_out)
┃                                               ▄▄▄▀▀▀▀▀▀▀▀▀
┃                                           ▄▄▀▀
┃                                        ▄▀▀
┃                                     ▄▄▀
┃                                   ▄▀
┃                                 ▄▀
┃                               ▄▀
┃                             ▄▀
┃                           ▄▀
┃                         ▄▀
┃                       ▄▀
┃                    ▄▀▀
┃                 ▄▄▀
┃             ▄▄▀▀
┃▄▄▄▄▄▄▄▄▄▄▀▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

`:quadratic`

```
# quadratic (in)
┃                                                         ▄▄
┃                                                       ▄▀
┃                                                     ▄▀
┃                                                   ▄▀
┃                                                 ▄▀
┃                                              ▄▀▀
┃                                            ▄▀
┃                                         ▄▀▀
┃                                      ▄▀▀
┃                                   ▄▀▀
┃                               ▄▄▀▀
┃                           ▄▄▀▀
┃                      ▄▄▄▀▀
┃                ▄▄▄▀▀▀
┃▄▄▄▄▄▄▄▄▄▄▄▀▀▀▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# quadratic (out)
┃                                            ▄▄▄▄▄▀▀▀▀▀▀▀▀▀▀
┃                                      ▄▄▄▀▀▀
┃                                 ▄▄▀▀▀
┃                             ▄▄▀▀
┃                         ▄▄▀▀
┃                      ▄▄▀
┃                   ▄▄▀
┃                ▄▄▀
┃              ▄▀
┃           ▄▄▀
┃         ▄▀
┃       ▄▀
┃     ▄▀
┃   ▄▀
┃▄▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

```
# quadratic (in_out)
┃                                                 ▄▄▄▀▀▀▀▀▀▀
┃                                            ▄▄▀▀▀
┃                                         ▄▀▀
┃                                      ▄▀▀
┃                                   ▄▄▀
┃                                 ▄▀
┃                               ▄▀
┃                             ▄▀
┃                           ▄▀
┃                         ▄▀
┃                      ▄▀▀
┃                   ▄▄▀
┃                ▄▄▀
┃           ▄▄▄▀▀
┃▄▄▄▄▄▄▄▄▀▀▀
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Full template example

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

### Full usage

```
Usage: whirled_peas <command> [command options]

Available commands:

    debug     Print template tree for specified frame
    fonts     List installed title fonts with sample text
    frames    Print out list of frames generated by application
    help      Show detailed help for a command
    play      Play an animation from an application or prerecorded file
    record    Record animation to a file
    still     Show the specified still frame
```

#### `debug`

Print the template tree for specified frame.

```
# Usage: whirled_peas debug <config file> <frame> [args as a JSON string]
% whirled_peas debug my_app.rb greeting '{"name":"World"}'
* WhirledPeas::Graphics::BoxPainter(TEMPLATE)
  - Dimensions(outer=140x27, content=120x15, grid=1x1)
  - Settings
    WhirledPeas::Settings::BoxSettings
      padding: Padding(left: 10, top: 6, right: 10, bottom: 6)
      align: :center
      width: 120
      flow: :t2b
      bold: true
      bg_color: BgColor(code=107, bright=true)
  - Children
    * WhirledPeas::Graphics::BoxPainter(Element-1)
      - Dimensions(outer=64x6, content=64x6, grid=1x1)
```

#### `fonts`

List all installed title fonts with sample text.

```
# Usage: whirled_peas fonts
```

#### `frames`

Print out list of frames generated by application.

```
# Usage: whirled_peas frames <config file>
% whirled_peas frames my_app.rb
Frame 'intro' displayed for 3 second(s) '{"title":"Foo"}'
Frame 'greet' displayed for 0.3 second(s)
...
```

#### `help`

Print out command-specific help message

```
Usage: whirled_peas help <command>
```

#### `play`

Play an animation from an application or prerecorded file

```
# Usage: whirled_peas play <config/wpz file>

# Play animation directly from app
% whirled_peas play my_app.rb
# Animation plays

# Play animation from previously recorded file
% whirled_peas play my_animation.wpz
# Animation plays
```

#### `record`

Record animation to a file

```
# Usage: whirled_peas record <config file> <output file>
% whirled_peas record my_app.rb my_animation.wpz
# Record animation to my_animation.wpz
```

#### `still`

Show the specified still frame

```
# Usage: whirled_peas still <config file> <frame> [args as a JSON string]
% whirled_peas still my_app.rb greeting '{"name":"World"}'
# Still frame is displayed
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Testing

In addition to standard RSpec tests, WhirledPeas has custom tests for rendered templates. These files live in `screen_test/`. Each ruby file is expected to define a class named `TemplateFactory` that responds to `#build(name, args)` returning a template (the standard template factory role). Each file should also be accompanied by a `.frame` file with the same base name. This file will contain the output of the rendered screen and is considered the correct output when running tests.

Note: viewing `.frame` files with `cat` works better than most other text editors.

```

Usage: screen_test [file] [options]

If not file or options are provide, all tests are run

If no file is provided, the supported options are
--help print this usage statement and exit
--view-pending interactively display and optionally save rendered output for each pending test
--view-failed interactively display and optionally save rendered output for each faiing test

If the file provide is a screen test, the supported options are
--run run screen test for given file
--view interactively display and optionally save the file's test output
--template print out template tree for the test template
--debug render the test template without displying it, printing out debug information

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/whirled_peas. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/whirled_peas/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WhirledPeas project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/whirled_peas/blob/master/CODE_OF_CONDUCT.md).

```

```
