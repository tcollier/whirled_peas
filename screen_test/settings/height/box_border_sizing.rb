require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box('Wide') do |_, settings|
        settings.full_border
        settings.padding.vert = 1
        settings.height = 6
        settings.sizing = :border
        "11\n22\n33\n44"
      end
    end
  end
end
