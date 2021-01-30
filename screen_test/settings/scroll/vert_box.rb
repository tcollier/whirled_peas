require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_box('Outer') do |composer, settings|
        settings.full_border
        settings.scrollbar.vert = true
        settings.height = 5
        settings.flow = :t2b
        settings.content_start.top = -4
        26.times.map do |i|
          ('A'.ord + i).chr
        end.join("\n")
      end
    end
  end
end
