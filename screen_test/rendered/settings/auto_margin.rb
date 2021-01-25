require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer, settings|
      settings.auto_margin = true
      'Hello'
    end
  end
end
