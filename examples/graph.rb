require 'bundler/setup'
require 'whirled_peas'
require 'whirled_peas/animator/easing'

module WhirledPeas
  PublicEasing = Animator::Easing
end

class TemplateFactory
  INNER_WIDTH = 60

  def build(name, args)
    WhirledPeas.template do |composer, settings|
      settings.bg_color = :bright_white
      settings.align = :center
      settings.valign = :middle
      composer.add_grid do |composer, settings|
        settings.num_cols = 2
        WhirledPeas::PublicEasing::EASING.keys.each do |func|
          easing = WhirledPeas::PublicEasing.new(func, :in_out)
          composer.add_box do |composer, settings|
            settings.flow = :t2b
            settings.set_padding(horiz: 4, vert: 2)
            composer.add_box do |_, settings|
              settings.margin.bottom = 1
              settings.color = :blue
              settings.underline = true
              "#{func} (in_out)"
            end
            composer.add_graph do |composer, settings|
              settings.axis_color = :black
              settings.color = :bright_blue
              settings.height = 15
              INNER_WIDTH.times.map do |i|
                easing.ease(i.to_f / (INNER_WIDTH - 1))
              end
            end
          end
        end
      end
    end
  end
end

class Application
  def start(producer)
    producer.add_frame('intro', duration: 5)
  end
end

WhirledPeas.configure do |config|
  config.template_factory = TemplateFactory.new
  config.application = Application.new
end
