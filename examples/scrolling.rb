require 'bundler/setup'
require 'whirled_peas'

class TemplateFactory
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
          settings.set_position(top: top)
          64.times do |i|
            composer.add_text { "%2d" % i }
          end
        end
      end
      composer.add_box('Horiz') do |composer, settings|
        settings.bg_color = :bright_red
        settings.full_border(color: :blue)
        settings.set_scrollbar(horiz: true)
        settings.width = 12
        composer.add_box('Inner') do |composer, settings|
          settings.set_position(left: top)
          '-\|/' * 16
        end
      end
    end
  end
end

class Driver
  def start(producer)
    53.times do |i|
      producer.send_frame('intro', duration: 0.1, args: { top: -i })
    end
  end
end

WhirledPeas.configure do |config|
  config.template_factory = TemplateFactory.new
  config.driver = Driver.new
end
