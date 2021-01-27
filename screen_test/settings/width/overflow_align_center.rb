require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box('Container') do |composer, settings|
        settings.width = 10
        settings.align = :center
        settings.full_border
        26.times do |i|
          composer.add_text("Inner-#{i}") { ('A'.ord + i).chr }
        end
      end
    end
  end
end
