require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer, settings|
      settings.set_padding(left: 10, top: 10)
      composer.add_box do |composer, settings|
        settings.full_border(color: :green)
        composer.add_grid do |_, settings|
          settings.set_position(top: 3)
          settings.full_border(color: :red)
          settings.num_cols = 1
          %w[12345 22344 33333 44322 54321]
        end
      end
    end
  end
end
