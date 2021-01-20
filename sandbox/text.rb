require_relative 'sandbox'

WhirledPeas.sandbox do |t|
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
