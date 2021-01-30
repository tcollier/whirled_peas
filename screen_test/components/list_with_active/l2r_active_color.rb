require 'whirled_peas'
require 'whirled_peas/component/list_with_active'

class TemplateFactory
  ITEMS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.chars

  def build(*)
    WhirledPeas.template(:test) do |composer, settings|
      WhirledPeas.component(composer, settings, :list_with_active) do |component|
        component.items = ITEMS
        component.active_index = ITEMS.length / 2
        component.viewport_size = 10
        component.active_color = :gray
        component.active_bg_color = :bright_white
      end
    end
  end
end
