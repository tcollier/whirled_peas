require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template(:test) do |composer|
      composer.add_grid('Alignment') do |composer, settings|
        settings.num_cols = 1
        settings.full_border
        settings.align = :center
        # Keep the title long so grids below will be wide enough to use the
        # alignment attribute. Don't rely on the `width` attribute to keep
        # `align` isolated in this test.
        composer.add_text('Title') { 'This is an aligned grid' }
        composer.add_text('Content') { 'Center' }
      end
    end
  end
end
