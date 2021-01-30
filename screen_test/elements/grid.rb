require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_grid('Grid') do |_, settings|
        settings.num_cols = 3
        settings.full_border
        7.times.map { |i| "Item #{i}" }
      end
    end
  end
end
