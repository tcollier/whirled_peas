require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_grid do |composer, settings|
        settings.full_border(style: :double, color: :green)
        settings.num_cols = 3
        12.times.map(&:itself)
      end
    end
  end
end
