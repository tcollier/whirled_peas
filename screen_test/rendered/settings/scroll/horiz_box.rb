require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer, settings|
      settings.full_border
      settings.set_scrollbar(horiz: true)
      settings.width = 5
      composer.add_box('Inner') do |composer, settings|
        settings.set_position(left: -4)
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      end
    end
  end
end