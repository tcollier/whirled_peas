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
