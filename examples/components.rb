require 'bundler/setup'
require 'whirled_peas'
require 'whirled_peas/component/list_with_active'

class TemplateFactory
  ITEMS = 400.times.map(&:itself)

  def build(name, args)
    active = args[:active]
    WhirledPeas.template do |composer, settings|
      WhirledPeas.component(composer, settings, :list_with_active) do |component, settings|
        component.items = %w[red orange yellow green blue indigo violet]
        component.separator = ', '
        component.active_index = active
        component.viewport_size = 27
        component.active_color = :green
        component.active_bg_color = :yellow
      end
    end
  end
end

class Application
  def start(producer)
    producer.frameset(5, easing: :parametric) do |fs|
      ITEMS.length.times { |i| fs.add_frame('intro', args: { active: i }) }
    end
    producer.add_frame('hold', duration: 1, args: { active: ITEMS.length - 1 })
  end
end

WhirledPeas.configure do |config|
  config.template_factory = TemplateFactory.new
  config.application = Application.new
end
