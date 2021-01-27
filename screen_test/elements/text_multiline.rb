require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      "Line 1\nLine 2\nLine 3"
    end
  end
end
