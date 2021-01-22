require_relative 'sandbox'

WhirledPeas.sandbox do |t|
  t.add_box do |outer, s|
    s.full_border
    s.set_margin(top: 10)
    s.auto_margin = true
    s.bg_color = :green
    s.color = :red
    s.set_padding(left: 10, right: 10, top: 4, bottom: 4)
    outer.add_text do |_, s|
      s.title_font = :default
      s.align = :center

      "Great Job!"
    end
  end
end
