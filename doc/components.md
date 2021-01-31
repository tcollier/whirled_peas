## Components

A component is a composition of the core building blocks. This gem includes a handful of components and third parties can also add components using `WhirledPeas.register_component(name, component_class)` (the convention for `name` is a snake cased symbol). A component class must be constructed with no arguments, though can supply basic setters to allow for customizations. A component must also implement `#compose(composer, settings)`, which should attach elements to the composer. Thus a template can integrate with the component like

```ruby
WhirledPeas.template do |composer, settings|
  # Attach the component registered with the name `:my_component` to the template
  WhirledPeas.component(composer, settings, :my_component) do |component|
    # Configure the component
  end
end
```

### `:list_with_active`

This component presents a list of content (either horizontally of vertically) and places the item specified by `active_index` in the preferred position.

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ green, blue, *indigo*, viole┃
┃           ▗▄▄▄▄▄▄▄▄▄▄▄▄▄▄▖  ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

Note: in the diagram above, the item specified by the active index is highlighted with `*`s, these are for illustration onlhy. The component can highlight the item with a color and/or background color, but will _not_ add the `*`s.

This component takes the following options

#### Required

- `active_index` - the index of the active item
- `items` - the array of items to be displayed in the box

#### Optional

- `active_bg_color` - background color of the active item
- `active_color` - text color of the active item
- `flow` - `:l2r` or `:t2b`
- `separator` - string used to separate items in the list, e.g. `", "` for a horizontal list or `"----"` for a vertical list
- `viewport_size` - number of characters of the viewport in the flow direction

### Example

```ruby
WhirledPeas.template do |composer, settings|
  WhirledPeas.component(composer, settings, :list_with_active) do |component|
    component.items = %w[red orange yellow green blue indigo violet]
    component.separator = ', '
    component.active_index = active
    component.viewport_size = 27
    component.active_color = :blue
    component.active_bg_color = :bright_yellow
  end
end
```
