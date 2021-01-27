require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box do |composer, settings|
        settings.flow = :r2l
        settings.full_border
        composer.add_box('Medium') do |composer, settings|
          settings.padding.vert = 2
          settings.full_border
          '1. MEDIUM'
        end
        composer.add_box('Tall') do |composer, settings|
          settings.padding.vert = 4
          settings.full_border
          '2. TALL'
        end
        composer.add_box('Short') do |composer, settings|
          settings.full_border
          '3. SHORT'
        end
      end
    end
  end
end
