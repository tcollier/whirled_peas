require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer, settings|
      settings.width = 10
      settings.flow = :t2b
      settings.full_border
      str = ''
      10.times do
        composer.add_text { str += 'XO' }
      end
    end
  end
end
