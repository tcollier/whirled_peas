require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_text('Title') do |_, settings|
        settings.title_font = :default
        "Hi!"
      end
    end
  end
end
