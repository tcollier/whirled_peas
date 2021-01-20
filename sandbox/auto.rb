require_relative 'sandbox'

WhirledPeas.sandbox do |t|
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
