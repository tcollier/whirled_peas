require 'bundler/setup'
require 'whirled_peas'
require 'whirled_peas/ui'

TEMPLATE = WhirledPeas.template do |t|
  t.add_box do |outer, outer_s|
    outer_s.full_border
    outer_s.bg_color = :green
    outer_s.set_padding(left: 3, right: 3, top: 1, bottom: 1)
    outer.add_box do |inner1, i1_s|
      i1_s.display_flow = :block
      inner1.add_box { "TOP LEFT" }
      inner1.add_box { "BOTTOM LEFT" }
    end
    outer.add_box do |inner2, i2_s|
      i2_s.display_flow = :block
      inner2.add_box { "TOP RIGHT "}
      inner2.add_box { "BOTTOM RIGHT "}
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
