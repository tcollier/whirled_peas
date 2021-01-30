require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_box('Outer') do |composer, settings|
        settings.full_border
        settings.align = :right
        settings.scrollbar.horiz = true
        settings.width = 5
        settings.content_start.left = -4
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      end
    end
  end
end
