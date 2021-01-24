require 'whirled_peas'

module TemplateFactory
  def self.build(name, args)
    WhirledPeas.template do |composer, settings|
      settings.flow = :l2r
      settings.full_border
      composer.add_box('Medium') do |composer, settings|
        settings.set_padding(top: 2, bottom: 2)
        settings.full_border
        '1. MEDIUM'
      end
      composer.add_box('Tall') do |composer, settings|
        settings.set_padding(top: 4, bottom: 4)
        settings.full_border
        '2. TALL'
      end
      composer.add_box('Short') do |composer, settings|
        settings.full_border
        '3. SHORT'
      end
    end
  end
end

WhirledPeas.configure do |config|
  config.template_factory = TemplateFactory
end
