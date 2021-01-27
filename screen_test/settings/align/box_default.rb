require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      composer.add_grid do |composer, settings|
        settings.num_cols = 2
        composer.add_box('Alignment') do |composer, settings|
          settings.flow = :t2b
          settings.full_border
          # Keep the title long so grids below will be wide enough to use the
          # alignment attribute. Don't rely on the `width` attribute to keep
          # `align` isolated in this test.
          composer.add_text('Title') { 'This is an aligned box' }
          composer.add_text('Content') { 'Default' }
        end
      end
    end
  end
end
