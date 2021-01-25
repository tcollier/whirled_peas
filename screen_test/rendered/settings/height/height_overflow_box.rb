require 'whirled_peas'

class TemplateFactory
  TALL_STRING = 10.times.map(&:to_s).join("\n")

  def build(*)
    WhirledPeas.template do |_, settings|
      settings.full_border
      settings.height = 5
      TALL_STRING
    end
  end
end
