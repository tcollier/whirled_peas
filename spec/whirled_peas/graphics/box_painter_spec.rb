require 'whirled_peas/graphics/box_painter'
require 'whirled_peas/settings/box_settings'
require 'whirled_peas/template/box_element'

module WhirledPeas
  module Graphics
    RSpec.describe BoxPainter do
      subject(:painter) { described_class.new(element, settings, 'Subject') }

      let(:element) { instance_double(Template::BoxElement) }
      let(:settings) { instance_double(Settings::BoxSettings, reverse_flow?: false) }

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

      [true, false].each do |flow|
        context "when the horizontal_flow? is #{flow}" do
          before { allow(settings).to receive(:horizontal_flow?).and_return(flow) }

          it 'returns num_cols/num_rows = 1' do
            dimensions = painter.dimensions
            expect(dimensions.num_cols).to eq(1)
            expect(dimensions.num_rows).to eq(1)
          end

          it 'returns content dimensions of 0 when there are no children' do
            dimensions = painter.dimensions
            expect(dimensions.content_width).to eq(0)
            expect(dimensions.content_height).to eq(0)
          end

          it 'returns content dimensions of only child' do
            painter.add_child(wide_child)
            dimensions = painter.dimensions
            expect(dimensions.content_width).to eq(4)
            expect(dimensions.content_height).to eq(2)
          end
        end
      end

      context 'when the flow is horizontal' do
        before do
          allow(settings).to receive(:horizontal_flow?).and_return(true)
          painter.add_child(wide_child)
          painter.add_child(tall_child)
        end

        it 'returns content_width as sum of child widths' do
          expect(painter.dimensions.content_width).to eq(5)
        end

        it 'returns content_height of the tallest child' do
          expect(painter.dimensions.content_height).to eq(8)
        end
      end

      context 'when the flow is vertical' do
        before do
          allow(settings).to receive(:horizontal_flow?).and_return(false)
          painter.add_child(wide_child)
          painter.add_child(tall_child)
        end

        it 'returns content_width of the widest child' do
          expect(painter.dimensions.content_width).to eq(4)
        end

        it 'returns content_height as sum of child height' do
          expect(painter.dimensions.content_height).to eq(10)
        end
      end
    end
  end
end
