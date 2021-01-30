require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer, settings|
      settings.flow = :t2b
      composer.add_text('Bold') do |_, settings|
        settings.bold = true
        'This is bold'
      end
      composer.add_text { 'This is not bold' }
    end
  end
end
