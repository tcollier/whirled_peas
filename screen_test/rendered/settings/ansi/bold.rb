require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_text('Bold') do |_, settings|
        settings.bold = true
        "This is bold"
      end
      composer.add_text('NotBold') do |_, settings|
        "This is not bold"
      end
    end
  end
end
