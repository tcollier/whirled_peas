require 'whirled_peas'

module TemplateFactory
  def self.build(name, args)
    WhirledPeas.template do |composer, _|
      composer.add_grid('Grid') do |composer, settings|
        settings.full_border(style: :double, color: :green)
        settings.num_cols = 3
        12.times.map { name }
      end
    end
  end
end

WhirledPeas.configure do |config|
  config.template_factory = TemplateFactory
end
