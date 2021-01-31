## Settings

Each element type has an associated settings type, which provide a custom set of options to format the output. Child settings will inherit from the parent, where applicable. The table below lists all settings along with which element types the settings can be applied to (`container` referes to either a `grid` or `box`)

| Setting         | Description                                                                             | Default    | Availability | Inherited            |
| --------------- | --------------------------------------------------------------------------------------- | ---------- | ------------ | -------------------- |
| `align`         | Justifies the content in the horizontal direction (see [Alignment](#alignment))         | `:left`    | containers   | No                   |
| `axis_color`    | Color used to paint the axes of the graph (see [Color](#color))                         |            | graph        | No                   |
| `bg_color`      | Background color (see [Color](#color))                                                  |            | all          | Yes                  |
| `bold`          | `true` makes the font bold                                                              | `false`    | all          | Yes                  |
| `border`        | Set the border for the element (see [Border](#border))                                  | none       | containers,  | Only style and color |
| `color`         | Foreground text color (see [Color](#color))                                             |            | all          | Yes                  |
| `flow`          | Flow to display child elements (see [Display Flow](#display-flow))                      | `:l2r`     | containers   | No                   |
| `height`        | Override the height of an element's content area (see [Dimension](#dimension))          |            | all          | No                   |
| `margin`        | Set the margin of the element (see [Margin](#margin))                                   | `0`        | containers   | No                   |
| `num_cols`      | Number of columns in the grid (must be set!)                                            |            | grid         | No                   |
| `padding`       | Set the padding of the element (see [Padding](#padding))                                | `0`        | containers   | No                   |
| `content_start` | Set the position of children (see [Content Start](#content-start))                      | `0`        | containers   | No                   |
| `scrollbar`     | Display a scroll bar for vertical or horizontal scrolling (see [Scrollbar](#scrollbar)) |            | box          | No                   |
| `sizing`        | Model that determines how width/height is calculated (see [Dimension](#dimension))      | `:content` | box          | No                   |
| `title_font`    | Font used for "large" text (see [Large Text](#large-text), ignores `underline`)         |            | text         | No                   |
| `underline`     | `true` underlines the font                                                              | `false`    | all          | Yes                  |
| `width`         | Override the width of an element's content area (see [Dimension](#dimension))           |            | all          | No                   |
| `valign`        | Justifies the content in the vertical direction (see [Alignment](#alignment))           | `:top`     | containers   | No                   |

### Alignment

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

### Content Start

Content start settings dictate the relative position from the content area where the children will get painted. Positive values for `left`/`top` result in moving the children leftward/downward, negative values shift children rightward/upward. Setting `right` or `bototm` will result in the end of the children to be painted relative to the right/bottom of the content area.

To set these values, use

- `set_content_start(left:, top:, right:, bottom:)`
- `content_start.left=`
- `content_start.top=`
- `content_start.right=`
- `content_start.bottom=`

Note: setting `left` and `right` or `top` and `bottom` is not supported

### Dimension

By default, the width and height of a container is calculated based on the width and height of its children. These values can be explicitly overridden to force the content into a specified dimensions. There are two sizing models that determine how the `width` and `height` settings are used to calculate the dimensions. The default sizing model is `:content`, which sets the width and height of the cotent area, whereas `:border` sets the width and height of the element inlcuding the padding and border and scroll bars.

#### Examples

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

### Margin

Margin settings dictate the spacing on the outside (i.e. outside of the border) of each of the 4 sides of the container independently. To set these values, use

- `set_margin(left:, top:, right:, bottom:, horiz:, vert:)` - set any combination of margin (note: setting `horiz` and `left`/`right` or setting `vert` and `top`/`bottom` is not allowed)
- `margin.left=(value)` - set left margin
- `margin.top=(value)` - set top margin
- `margin.right=(value)` - set right margin
- `margin.bottom=(value)` - set bottom margin
- `margin.horiz=(value)` - set left and right margin to the same value
- `margin.vert=(value)` - set top and bottom margin to the same value

Note: values cannot be negative

### Padding

Padding settings dictate the spacing on the inside (i.e. inside of the border) of each of the 4 sides of the container independently. To set these values, use

- `set_padding(left:, top:, right:, bottom:, horiz:, vert:)` - set any combination of padding (note: setting `horiz` and `left`/`right` or setting `vert` and `top`/`bottom` is not allowed)
- `padding.left=(value)` - set left padding
- `padding.top=(value)` - set top padding
- `padding.right=(value)` - set right padding
- `padding.bottom=(value)` - set bottom padding
- `padding.horiz=(value)` - set left and right padding to the same value
- `padding.vert=(value)` - set top and bottom padding to the same value

Note: values cannot be negative

### Scrollbar

Scroll settings dictate whether the scrollbar will be shown when child content is larger the the container's viewport. A scrollbar adds a unit to the dimensions of a container (as opposed to overwriting the leftmost/bottommost padding)

- `set_scrollbar(horiz:, vert:)` - set both scrollbar settings
- `scrollbar.horiz=(flag)` - show/hide the horizontal scrollbar
- `scrollbar.vert=(flag)` - show/hide the vertical scrollbar

Note: there is a know bug with scrollbars and `center`/`right` alignments. Using `left` alignment is the supported workaround

### Border

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

### Display Flow

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

### Color

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

### Large Text

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
