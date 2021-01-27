require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box do |composer, settings|
        settings.flow = :b2t
        settings.full_border
        composer.add_box('Medium') do |composer, settings|
          settings.full_border
          settings.set_padding(left:  3, right: 3)
          '1. MEDIUM'
        end
        composer.add_box('Wide') do |composer, settings|
          settings.full_border
          settings.set_padding(left:  7, right: 7)
          '2. WIDE'
        end
        composer.add_box('Narrow') do |composer, settings|
          settings.full_border
          '3. NARROW'
        end
      end
    end
  end
end
