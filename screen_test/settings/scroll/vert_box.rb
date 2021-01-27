require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box('Outer') do |composer, settings|
        settings.full_border
        settings.scrollbar.vert = true
        settings.height = 5
        composer.add_box('Inner') do |composer, settings|
          settings.flow = :t2b
          settings.set_position(top: -4)
          26.times do |i|
            composer.add_text { ('A'.ord + i).chr }
          end
        end
      end
    end
  end
end
