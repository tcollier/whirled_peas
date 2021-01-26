require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box('Wide') do |_, settings|
        settings.full_border
        settings.set_padding(left: 5, right: 4)
        settings.width = 20
        settings.sizing = :border
        "12345678901234567890"
      end
    end
  end
end
