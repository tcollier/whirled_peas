require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box('Container') do |composer, settings|
        settings.width = 3
        settings.set_margin(left: 3)
        settings.align = :center
        # settings.full_border
        '123456'
      end
    end
  end
end
