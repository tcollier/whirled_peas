require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer, settings|
      settings.set_padding(left: 5, top: 5)
      composer.add_box do |composer, settings|
        settings.full_border(color: :green)
        settings.content_start.top = 3
        composer.add_grid do |_, settings|
          settings.full_border(color: :red)
          settings.num_cols = 1
          %w[12345 22344 33333 44322 54321]
        end
      end
    end
  end
end
