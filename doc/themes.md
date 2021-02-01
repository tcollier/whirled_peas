## Themes

The template builder (`WhirledPeas.template`) takes an optional `theme` argument. You can provide the name of a predefined theme (run `whirled_peas themes` to see a list with samples) or define you own with the following

```ruby
WhirledPeas.register_theme(:my_theme) do |theme|
  theme.bg_color = :bright_white
  theme.color = :blue
  theme.border_color = :bright_green
  theme.axis_color = :bright_red
  theme.title_font = :default
end
```

Theme settings will be used as default settings throughout the template, however theme settings can be overridden on any element.

### Theme Settings

The following theme settings override the existing default settings for all elements.

- `axis_color` - axis color for graphs (defaults to `border_color`)
- `bg_color` - background color (defaults to system color)
- `border_color` - border color (defaults to `color`)
- `border_style` - border style (defaults to `bold`)
- `color` - text color (defaults to system color)

The following theme settings provide new options that can be applied to existing settings. E.g.

```ruby
WhirledPeas.register_theme(:my_theme) do |theme|
  theme.highlight_bg_color = :bright_white
  theme.highlight_color = :red
  # ...
end

WhirledPeas.template(:my_theme) do |composer, settings|
  # ...
  composer.add_text do |composer, settings|
    composer.bg_color = :highlight
    composer.color = :highlight
    "This Is Important!!!"
  end
end
```

- `highlight_bg_color` - provides a new `:highlight` option that can be applied to `bg_color` settings (defaults to `color`)
- `highlight_color` - provides a new `:highlight` option that can be applied to `color` settings (defaults to `bg_color`)
- `title_font` - provides a new `:theme` option that can be applied to `title_font` settings (defaults to system default)

Note: the defaults for the `highlight_bg_color` and `highlight_color` options result in inverting the background and text colors.
