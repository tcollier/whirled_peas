require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer, _|
      composer.add_text('Underline') do |_, settings|
        settings.underline = true
        "This is underlined"
      end
      composer.add_text('NotUnderline') do |_, settings|
        "This is not underlined"
      end
    end
  end
end
