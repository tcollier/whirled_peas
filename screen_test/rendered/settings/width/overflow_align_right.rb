require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box do |composer, settings|
        settings.width = 10
        settings.align = :right
        settings.full_border
        26.times do |i|
          composer.add_text("Inner-#{i}") { ('A'.ord + i).chr }
        end
      end
    end
  end
end
