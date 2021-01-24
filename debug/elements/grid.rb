require 'whirled_peas'

module TemplateFactory
  def self.build(name, args)
    num_cols = args[:num_cols] || 3
    WhirledPeas.template do |composer|
      composer.add_grid('Grid') do |_, settings|
        settings.num_cols = num_cols
        settings.full_border
        7.times.map { name }
      end
    end
  end
end

WhirledPeas.configure do |config|
  config.template_factory = TemplateFactory
end
