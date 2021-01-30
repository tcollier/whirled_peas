require 'whirled_peas'

WhirledPeas.define_theme(:theme_test) do |theme|
  theme.bg_color = :bright_white
  theme.color = :blue
  theme.border_color = :bright_green
  theme.axis_color = :bright_red
  theme.title_font = :default
end

class TemplateFactory
  def build(*)
    WhirledPeas.template(:theme_test) do |composer, settings|
      settings.full_border
      settings.flow = :t2b
      composer.add_text do |_, settings|
        settings.title_font = :theme
        'OOH'
      end
      composer.add_graph do |_, settings|
        settings.height = 12
        20.times.map { |i| Math.sqrt(i) }
      end
    end
  end
end
