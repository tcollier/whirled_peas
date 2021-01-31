## Template Factory

To render the frame events sent by the application, the application requires a template factory. This factory will be called for each frame event, with the frame name and the arguments supplied by the application. A template factory can be an instance of ruby class and thus can maintain state. Whirled Peas provides a few basic building blocks to make simple, yet elegant terminal-based UIs.

To build a template in a template factory, use `WhirledPeas.template(theme)`, which takes an optional [theme](themes.md) and yields a composer (used to add [elements](elements.md) to the template) and [settings](settings.md) (used to configure the element).

### Full example

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
