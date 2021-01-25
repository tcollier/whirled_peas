require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_grid('Wide') do |_, settings|
        settings.full_border
        settings.width = 30
        settings.num_cols = 2
        6.times.map { "How big is it?" }
      end
    end
  end
end
