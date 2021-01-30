require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do
      '-' * 1000
    end
  end
end
