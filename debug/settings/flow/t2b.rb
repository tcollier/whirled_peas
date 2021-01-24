require 'whirled_peas'

module TemplateFactory
  def self.build(name, args)
    WhirledPeas.template do |composer, settings|
      settings.flow = :t2b
      settings.full_border
      composer.add_box('Medium') do |composer, settings|
        settings.full_border
        settings.set_padding(left:  3, right: 3)
        '1. MEDIUM'
      end
      composer.add_box('Wide') do |composer, settings|
        settings.full_border
        settings.set_padding(left:  7, right: 7)
        '2. WIDE'
      end
      composer.add_box('Narrow') do |composer, settings|
        settings.full_border
        '3. NARROW'
      end
    end
  end
end

WhirledPeas.configure do |config|
  config.template_factory = TemplateFactory
end
