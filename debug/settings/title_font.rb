require 'whirled_peas'

module TemplateFactory
  def self.build(name, _)
    WhirledPeas.template do |composer|
      composer.add_text('Title') do |_, settings|
        settings.title_font = :default
        name
      end
    end
  end
end

WhirledPeas.configure do |config|
  config.template_factory = TemplateFactory
end
