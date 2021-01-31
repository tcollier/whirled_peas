## Building Blocks

A template is created with `WhirledPeas.template`, which yields a composer object for a box and its associated settings. The composer allows for attaching child elements and the settings for setting layout options. The following attributes of the template's settings will be overridden before it is rendered to ensure that it fills the screen exactly

- `margin` - all margin will be set to 0
- `width` - will be set to the screen's width
- `height` - will be set to the screen's height
- `sizing` - will be set `:border` to ensure the entire box fits on the screen and fills it entirely.

A composer provides the following methods to add child elements, each of these takes an optional string argument that is set as the name of the element (which can be useful when debugging).

- `add_box` - yields a composer for a box and associated settings, which will be added to the parent's children
- `add_graph` - yields a `nil` and settings for a graph element, which will be added to the parent's children, the block should return an array of numbers to be plotted
- `add_grid` - yields a composer for a grid and associated settings, which will be added to the parent's children
- `add_text` - yields `nil` and settings for a text element, which will be added to the parent's children

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
