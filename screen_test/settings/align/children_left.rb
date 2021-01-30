require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_box do |composer, settings|
        settings.align = :left
        settings.width = 28
        settings.full_border
        composer.add_text('Text1') { 'Thing 1' }
        composer.add_text('Text2') { 'Thing 2' }
      end
    end
  end
end
