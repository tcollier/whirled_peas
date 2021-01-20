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
    6.times.map { |i| (i + 1).to_s }
  end
end

module WhirledPeas
  if ARGV.last == '--debug'
    puts TEMPLATE.inspect
    screen = UI::Screen.new(false)
  else
    screen = UI::Screen.new
  end
  screen.paint(TEMPLATE)
  screen.finalize
end
