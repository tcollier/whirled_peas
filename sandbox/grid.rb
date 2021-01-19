require 'bundler/setup'
require 'whirled_peas'
require 'whirled_peas/ui'

TEMPLATE = WhirledPeas.template do |t|
  t.add_grid do |grid, settings|
    settings.num_cols = 3
    settings.bg_color = :yellow
    settings.color = :blue
    settings.set_margin(top: 3, left: 10)
    settings.set_padding(top: 1, bottom: 1, left: 3, right: 3)
    settings.full_border(color: :green)
    6.times.each { |i| grid.add_text { (i + 1).to_s } }
  end
end

module WhirledPeas
  screen = UI::Screen.new
  screen.paint(TEMPLATE)
  screen.finalize
end
