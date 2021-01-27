require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer, settings|
      composer.add_grid do |_, settings|
        settings.flow = :r2l
        settings.full_border
        settings.num_cols = 4
        10.times.map { |i| i + 1 }
      end
    end
  end
end
