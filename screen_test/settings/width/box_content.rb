require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_box('Wide') do |_, settings|
        settings.full_border
        settings.set_padding(left: 3, right: 4)
        settings.width = 15
        settings.sizing = :content
        '15/content'
      end
    end
  end
end
