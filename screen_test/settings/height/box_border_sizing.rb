require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box('Wide') do |_, settings|
        settings.full_border
        settings.set_padding(top: 1, bottom: 1)
        settings.height = 6
        settings.sizing = :border
        "11\n22\n33\n44"
      end
    end
  end
end
