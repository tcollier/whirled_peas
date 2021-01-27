require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box('Tall') do |_, settings|
        settings.full_border
        settings.height = 5
        "Multi\nLine"
      end
    end
  end
end
