require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_box do |composer, settings|
        settings.flow = :t2b
        settings.full_border
        settings.valign = :evenly
        settings.height = 15
        composer.add_text { 'A' }
        composer.add_text { 'B' }
        composer.add_text { 'C' }
      end
    end
  end
end
