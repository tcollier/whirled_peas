require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box do |composer, settings|
        settings.align = :right
        settings.width = 28
        settings.full_border
        composer.add_text('Text1') { 'Thing 1' }
        composer.add_text('Text2') { 'Thing 2' }
      end
    end
  end
end
