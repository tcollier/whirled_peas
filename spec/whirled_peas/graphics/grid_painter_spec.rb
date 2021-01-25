require 'whirled_peas/settings/grid_settings'
require 'whirled_peas/graphics/grid_painter'
require 'whirled_peas/template/grid_element'

module WhirledPeas
  module Graphics
    RSpec.describe GridPainter do
      describe '#dimensions' do
        subject(:painter) { described_class.new(element, settings, 'Subject') }

        let(:element) { instance_double(Template::GridElement) }
        let(:settings) do
          instance_double(Settings::GridSettings, width: nil, num_cols: 3)
        end
        let(:wide_child) do
          instance_double(
            Painter,
            dimensions: double('Dimensions', outer_width: 4, outer_height: 2)
          )
        end
        let(:tall_child) do
          instance_double(
            Painter,
            dimensions: double('Dimensions', outer_width: 1, outer_height: 8)
          )
        end

        it 'returns num_cols from settings' do
          dimensions = painter.dimensions
          expect(dimensions.num_cols).to eq(3)
        end

        it 'returns num_rows based on num_cols and number of children' do
          5.times { painter.add_child(wide_child) }
          dimensions = painter.dimensions
          expect(dimensions.num_rows).to eq(2)
        end

        it 'returns content dimensions of 0 when there are no children' do
          dimensions = painter.dimensions
          expect(dimensions.content_width).to eq(0)
          expect(dimensions.content_height).to eq(0)
          expect(dimensions.num_rows).to eq(0)
        end

        it 'returns content_width of widest child' do
          painter.add_child(wide_child)
          painter.add_child(tall_child)
          dimensions = painter.dimensions
          expect(dimensions.content_width).to eq(4)
        end

        it 'returns content_height of tallest child' do
          painter.add_child(wide_child)
          painter.add_child(tall_child)
          dimensions = painter.dimensions
          expect(dimensions.content_height).to eq(8)
        end
      end
    end
  end
end
