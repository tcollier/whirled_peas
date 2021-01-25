require 'bundler/setup'
require 'whirled_peas'

class TemplateFactory
  TITLE_FONT = :default #roman
  PRIMARY_COLOR = :bright_blue
  SECONDARY_COLOR = :blue
  BG_COLOR = :bright_white

  def build(name, args)
    WhirledPeas.template do |composer, settings|
      settings.set_padding(left: 10, top: 6, right: 10, bottom: 6)
      settings.align = :center
      settings.width = 120
      settings.flow = :t2b
      settings.bold = true
      settings.bg_color = BG_COLOR

      composer.add_box do |composer, settings|
        composer.add_text do |_, settings|
          settings.title_font = TITLE_FONT
          settings.color = PRIMARY_COLOR
          'Visualize'
        end
      end
      composer.add_box do |_, settings|
        settings.set_margin(top: 1)
        settings.color = SECONDARY_COLOR
        "your code's execution with"
      end
      composer.add_box do |composer, settings|
        settings.set_margin(top: 1)
        composer.add_text do |_, settings|
          settings.title_font = TITLE_FONT
          settings.color = PRIMARY_COLOR
          'Whirled Peas'
        end
      end
    end
  end
end

class Driver
  def start(producer)
    producer.send_frame('intro', duration: 5)
  end
end

WhirledPeas.configure do |config|
  config.template_factory = TemplateFactory.new
  config.driver = Driver.new
end
