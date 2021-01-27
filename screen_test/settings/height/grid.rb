require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_grid('Tall') do |_, settings|
        settings.full_border
        settings.num_cols = 4
        settings.height = 5
        10.times.map(&:itself)
      end
    end
  end
end
