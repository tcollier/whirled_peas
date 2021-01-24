require 'whirled_peas'

module TemplateFactory
  COLORS = %i[
    black
    gray
    red
    green
    yellow
    blue
    magenta
    cyan
    white
    bright_red
    bright_green
    bright_yellow
    bright_blue
    bright_magenta
    bright_cyan
    bright_white
  ]
  def self.build(name, _)
    WhirledPeas.template do |composer|
      composer.add_grid('Colors') do |composer, settings|
        settings.num_cols = 1
        COLORS.each.with_index do |color, index|
          bg_color = COLORS[(index + COLORS.length / 2) % COLORS.length]
          composer.add_text("#{color.upcase}-#{bg_color.upcase}") do |_, settings|
            settings.color = color
            settings.bg_color = bg_color
            "#{color.upcase} on #{bg_color.upcase}"
          end
        end
      end
    end
  end
end

WhirledPeas.configure do |config|
  config.template_factory = TemplateFactory
end
