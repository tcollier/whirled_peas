require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box do |_, settings|
        settings.full_border
        settings.set_padding(left: 5, top: 2, right: 3, bottom: 1)
        "Padded Room"
      end
    end
  end
end
