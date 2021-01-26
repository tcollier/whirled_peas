require 'whirled_peas'

class TemplateFactory
  TALL_STRING = 10.times.map(&:to_s).join("\n")

  def build(*)
    WhirledPeas.template do |composer|
      composer.add_box do |composer, settings|
        settings.full_border
        settings.height = 5
        3.times do |i|
          composer.add_text { TALL_STRING }
        end
      end
    end
  end
end
