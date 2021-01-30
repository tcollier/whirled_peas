require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_box do |composer, settings|
        settings.flow = :t2b
        settings.height = 5
        settings.full_border
        10.times do
          composer.add_text { 'XO' }
        end
      end
    end
  end
end
