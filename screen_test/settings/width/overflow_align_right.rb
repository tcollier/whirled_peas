require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box do |composer, settings|
        settings.width = 3
        settings.align = :right
        settings.full_border
        '123456'
      end
    end
  end
end
