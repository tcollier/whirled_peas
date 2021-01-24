require 'whirled_peas'

module TemplateFactory
  def self.build(name, args)
    WhirledPeas.template do |composer|
      "Hello, World!"
    end
  end
end

WhirledPeas.configure do |config|
  config.template_factory = TemplateFactory
end
