require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box do |composer, settings|
        settings.flow = :t2b
        settings.full_border
        settings.valign = :around
        settings.height = 15
        composer.add_text { 'A' }
        composer.add_text { 'B' }
        composer.add_text { 'C' }
      end
    end
  end
end
