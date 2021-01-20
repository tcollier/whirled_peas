require 'bundler/setup'
require 'whirled_peas'
require 'whirled_peas/ui'

TEMPLATE = WhirledPeas.template do |t|
  t.add_box do |outer, s|
    s.full_border
    s.bg_color = :green
    s.width = 100
    outer.add_box do |inner, s|
      s.auto_margin = true
      "MIDDLE"
    end
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
