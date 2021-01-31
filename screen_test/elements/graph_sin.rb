require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_graph('Graph') do |_, settings|
        settings.height = 12
        [6, 9, 11, 12, 11, 9, 6, 3, 1, 0, 1, 3, 6]
      end
    end
  end
end
