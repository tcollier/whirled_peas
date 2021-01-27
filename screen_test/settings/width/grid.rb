require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_grid('Wide') do |_, settings|
        settings.full_border
        settings.width = 6
        settings.num_cols = 2
        6.times.map { '6' }
      end
    end
  end
end
