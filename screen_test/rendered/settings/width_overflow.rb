require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |_, settings|
      settings.width = 10
      settings.full_border
      "ABCDEFGHIJKLMNOPQRSTUVWZYZ"
    end
  end
end
