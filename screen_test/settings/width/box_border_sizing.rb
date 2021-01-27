require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box('Wide') do |_, settings|
        settings.full_border
        settings.set_padding(left: 3, right: 4)
        settings.width = 15
        settings.sizing = :border
        '15/border'
      end
    end
  end
end
