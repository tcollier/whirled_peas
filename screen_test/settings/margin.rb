require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_box do |composer, settings|
        settings.full_border
        composer.add_box do |_, settings|
          settings.set_margin(left: 5, top: 2, right: 3, bottom: 1)
          settings.full_border
          'Inner Box'
        end
      end
    end
  end
end
