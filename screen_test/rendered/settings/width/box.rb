require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer, _|
      composer.add_box('Wide') do |_, settings|
        settings.full_border
        settings.width = 50
        "How big is it?"
      end
    end
  end
end
