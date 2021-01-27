require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_grid do |_, settings|
        settings.flow = :b2t
        settings.full_border
        settings.num_cols = 4
        14.times.map { |i| i + 1 }
      end
    end
  end
end
