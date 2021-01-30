require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer, settings|
      settings.flow = :t2b
      composer.add_text('Underline') do |_, settings|
        settings.underline = true
        'This is underlined'
      end
      composer.add_text { 'This is not underlined' }
    end
  end
end
