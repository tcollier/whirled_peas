require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer, settings|
      settings.align = :center
      settings.width = 50
      settings.full_border
      composer.add_text('Text1') { 'Thing 1' }
      composer.add_text('Text2') { 'Thing 2' }
    end
  end
end
