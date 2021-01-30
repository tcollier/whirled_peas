require 'whirled_peas'

class TemplateFactory
  TALL_STRING = 10.times.map(&:to_s).join("\n")

  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_grid('TallGrid') do |composer, settings|
        settings.full_border
        settings.height = 5
        settings.num_cols = 1
        composer.add_text { TALL_STRING }
      end
    end
  end
end
