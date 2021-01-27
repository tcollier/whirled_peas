require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box('Outer') do |composer, settings|
        settings.full_border
        settings.align = :center
        settings.scrollbar.horiz = true
        settings.width = 5
        composer.add_box('Inner') do |composer, settings|
          settings.set_position(left: -4)
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        end
      end
    end
  end
end
