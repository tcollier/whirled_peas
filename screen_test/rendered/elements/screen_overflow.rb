require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do
      '-' * 1000
    end
  end
end
