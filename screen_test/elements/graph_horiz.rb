require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_graph('Graph') do |_, settings|
        settings.height = 12
        [5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
      end
    end
  end
end
