require 'whirled_peas'

module TemplateFactory
  def self.build(name, _)
    WhirledPeas.template do |composer, settings|
      settings.auto_margin = true
      name
    end
  end
end

WhirledPeas.configure do |config|
  config.template_factory = TemplateFactory
end
