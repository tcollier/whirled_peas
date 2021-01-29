require 'bundler/setup'
require 'whirled_peas'

class TemplateFactory
  HPADDING = 0
  VPADDING = 0
  ITEM_COUNT = 64

  def build(name, args)
    top = args[:top]
    WhirledPeas.template do |composer, settings|
      settings.color = :green
      composer.add_box('Vert') do |composer, settings|
        settings.bg_color = :bright_red
        settings.full_border(color: :blue)
        settings.set_scrollbar(vert: true)
        settings.height = 12
        composer.add_box('Inner') do |composer, settings|
          settings.flow = :t2b
          settings.set_padding(left: HPADDING, right: HPADDING, top: VPADDING, bottom: VPADDING)
          settings.set_position(top: top)
          ITEM_COUNT.times do |i|
            composer.add_text { "%2d" % i }
          end
        end
      end
      composer.add_box('Horiz') do |composer, settings|
        settings.bg_color = :bright_red
        settings.full_border(color: :blue)
        settings.set_padding(left: HPADDING, right: HPADDING, top: VPADDING, bottom: VPADDING)
        settings.set_scrollbar(horiz: true)
        settings.width = 12
        composer.add_box('Inner') do |composer, settings|
          settings.set_position(left: top)
          ITEM_COUNT.times.map { |i| (i % 10).to_s }.join
        end
      end
    end
  end
end

class Application
  def start(producer)
    producer.frameset(5, easing: :bezier) do |fs|
      53.times { |i| fs.add_frame('intro', args: { top: -i }) }
    end
    producer.add_frame('hold', duration: 1, args: { top: -52})
  end
end

WhirledPeas.configure do |config|
  config.template_factory = TemplateFactory.new
  config.application = Application.new
end
