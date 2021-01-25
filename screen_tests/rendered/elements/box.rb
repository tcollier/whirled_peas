require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box('Container') do |composer, settings|
        composer.add_box do |composer, settings|
          settings.flow = :t2b
          composer.add_box('TopLeft') { "TOP LEFT" }
          composer.add_box('BottomLeft') { "BOTTOM LEFT" }
        end
        composer.add_box do |composer, settings|
          settings.flow = :t2b
          composer.add_box('TopRight') { " TOP RIGHT   " }
          composer.add_box('BottomRight') { " BOTTOM RIGHT" }
        end
      end
    end
  end
end
