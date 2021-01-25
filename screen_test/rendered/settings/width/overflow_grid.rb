require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer, settings|
      composer.add_grid('grid') do |_, settings|
        settings.width = 10
        settings.full_border
        settings.num_cols = 1
        ["ABCDEFGHIJKLMNOPQRSTUVWZYZ"]
      end
    end
  end
end
