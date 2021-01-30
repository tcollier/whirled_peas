require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_box do |composer, settings|
        settings.width = 10
        settings.full_border
        str = ''
        10.times do |i|
          composer.add_text { str += "#{i}|" }
        end
      end
    end
  end
end
