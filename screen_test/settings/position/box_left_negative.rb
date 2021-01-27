require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer, settings|
      settings.set_padding(left: 5, top: 5)
      composer.add_box do |composer, settings|
        settings.full_border(color: :green)
        composer.add_box do |_, settings|
          settings.set_position(left: -3)
          settings.full_border(color: :red)
          %w[12345 22344 33333 44322 54321].join("\n")
        end
      end
    end
  end
end