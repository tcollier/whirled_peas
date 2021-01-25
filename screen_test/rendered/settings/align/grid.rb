require 'whirled_peas'

class TemplateFactory
  def build(*)
    WhirledPeas.template do |composer|
      [nil, :left, :center, :right].each do |align|
        composer.add_grid("Alignment-#{align || :default}") do |composer, settings|
          settings.num_cols = 1
          settings.full_border
          settings.align = align
          # Keep the title long so grids below will be wide enough to use the
          # alignment attribute. Don't rely on the `width` attribute to keep
          # `align` isolated in this test.
          composer.add_text('Title') { 'This is an aligned grid' }
          composer.add_text('Content') { align || :default }
        end
      end
    end
  end
end
