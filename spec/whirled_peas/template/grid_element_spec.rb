require 'whirled_peas/settings/grid_settings'
require 'whirled_peas/template/grid_element'

module WhirledPeas
  module Template
    RSpec.describe GridElement do
      describe '#dimensions' do
        subject(:element) { described_class.new('Subject', settings) }

        let(:settings) { instance_double(Settings::GridSettings, num_cols: 3) }
        let(:wide_child) do
          instance_double(
            Element,
            dimensions: double('Dimensions', outer_width: 4, outer_height: 2)
          )
        end
        let(:tall_child) do
          instance_double(
            Element,
            dimensions: double('Dimensions', outer_width: 1, outer_height: 8)
          )
        end

        it 'returns num_cols from settings' do
          dimensions = element.dimensions
          expect(dimensions.num_cols).to eq(3)
        end

        it 'returns num_rows based on num_cols and number of children' do
          5.times { element.add_child(wide_child) }
          dimensions = element.dimensions
          expect(dimensions.num_rows).to eq(2)
        end

        it 'returns content dimensions of 0 when there are no children' do
          dimensions = element.dimensions
          expect(dimensions.content_width).to eq(0)
          expect(dimensions.content_height).to eq(0)
          expect(dimensions.num_rows).to eq(0)
        end

        it 'returns content_width of widest child' do
          element.add_child(wide_child)
          element.add_child(tall_child)
          dimensions = element.dimensions
          expect(dimensions.content_width).to eq(4)
        end

        it 'returns content_height of tallest child' do
          element.add_child(wide_child)
          element.add_child(tall_child)
          dimensions = element.dimensions
          expect(dimensions.content_height).to eq(8)
        end
      end
    end
  end
end
