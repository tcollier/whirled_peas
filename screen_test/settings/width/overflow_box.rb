require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_box do |_, settings|
        settings.width = 10
        settings.full_border
        "ABCDEFGHIJKLMNOPQRSTUVWZYZ"
      end
    end
  end
end
