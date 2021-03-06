require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_grid do |_, settings|
        settings.flow = :b2t
        settings.full_border
        settings.num_cols = 4
        10.times.map { |i| i + 1 }
      end
    end
  end
end
