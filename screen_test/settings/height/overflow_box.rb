require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box do |_, settings|
        settings.full_border
        settings.height = 5
        "XO\n" * 10
      end
    end
  end
end
