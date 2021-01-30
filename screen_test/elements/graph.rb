require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_graph('Graph') do |_, settings|
        settings.height = 12
        10.times.map { |i| i ** 2 }
      end
    end
  end
end
