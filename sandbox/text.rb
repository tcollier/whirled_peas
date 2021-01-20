require 'bundler/setup'
require 'whirled_peas'
require 'whirled_peas/ui'

TEMPLATE = WhirledPeas.template do |t|
  t.add_text do |_, settings|
    settings.bg_color = :green
    settings.align = :right
    settings.width = 30
    "HELLO"
  end
  t.add_text do |_, settings|
    settings.bg_color = :red
    settings.align = :center
    settings.width = 30
    "WORLD"
  end
  t.add_text do |_, settings|
    settings.bg_color = :green
    settings.width = 4
    "1234567890"
  end
  t.add_text do |_, settings|
    settings.bg_color = :red
    settings.align = :center
    settings.width = 4
    "1234567890"
  end
  t.add_text do |_, settings|
    settings.bg_color = :green
    settings.align = :right
    settings.width = 4
    "1234567890"
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
