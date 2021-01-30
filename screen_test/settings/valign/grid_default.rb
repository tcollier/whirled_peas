require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_grid('Alignment') do |composer, settings|
        settings.num_cols = 1
        settings.full_border
        settings.height = 3
        composer.add_text { 'A' }
      end
    end
  end
end
