require 'whirled_peas/settings/border'
require 'whirled_peas/graphics/canvas'
require 'whirled_peas/graphics/container_coords'
require 'whirled_peas/settings/container_settings'
require 'whirled_peas/settings/margin'
require 'whirled_peas/settings/padding'
require 'whirled_peas/settings/scrollbar'

module WhirledPeas
  module Graphics
    RSpec.describe ContainerCoords do
      subject(:coords) { described_class.new(dimensions, settings, 21, 17) }

      let(:dimensions) do
        instance_double(ContainerDimensions, outer_width: 50, content_width: 23, content_height: 9)
      end
      let(:settings) do
        instance_double(
          Settings::ContainerSettings,
          position: position,
          margin: margin,
          border: border,
          padding: padding,
          scrollbar: scrollbar
        )
      end
      let(:position) { instance_double(Settings::Position, left: 3, top: 1) }
      let(:margin) { instance_double(Settings::Margin, left: 13, top: 5) }
      let(:border) do
        instance_double(Settings::Border, left?: true, top?: true, inner_horiz?: true, inner_vert?: true)
      end
      let(:padding) { instance_double(Settings::Padding, left: 7, top: 3, right: 4, bottom: 2) }
      let(:scrollbar) { instance_double(Settings::Scrollbar, vert?: false, horiz?: false) }

      describe '#left' do
        it 'returns start_left + position.left' do
          expect(coords.left).to eq(24)
        end
      end

      describe '#border_left' do
        it 'returns #left plus the left margin' do
          expect(coords.border_left).to eq(37)
        end
      end

      describe '#padding_left' do
        context 'without a left border' do
          before { allow(border).to receive(:left?).and_return(false) }

          it 'returns #border_left' do
            expect(coords.padding_left).to eq(37)
          end
        end

        context 'with a left border' do
          before { allow(border).to receive(:left?).and_return(true) }

          it 'returns #border_left plus one' do
            expect(coords.padding_left).to eq(38)
          end
        end
      end

      describe '#content_left' do
        before do
          allow(border).to receive(:left?).and_return(true)
          allow(border).to receive(:inner_vert?).and_return(true)
        end

        it 'returns #border_left plus the left padding' do
          expect(coords.content_left).to eq(45)
        end

        context 'when col_index > 0' do
          it 'returns #border_left plus left padding plus col_index grid_widths' do
            # content_left (42) + col_index (3) * grid_width (35)
            expect(coords.content_left(3)).to eq(150)
          end
        end
      end

      describe '#grid_width' do
        before { allow(border).to receive(:inner_vert?).and_return(true) }

        it 'returns the width of the content plus left/right padding plus one' do
          expect(coords.grid_width).to eq(35)
        end
      end

      describe '#inner_grid_width' do
        it 'returns the width of the content plus left/right padding' do
          expect(coords.inner_grid_width).to eq(34)
        end
      end

      describe '#top' do
        it 'returns #start_top plus position.top' do
          expect(coords.top).to eq(18)
        end
      end

      describe '#border_top' do
        it 'returns #top plus the top margin' do
          expect(coords.border_top).to eq(23)
        end
      end

      describe '#padding_top' do
        context 'without a top border' do
          before { allow(border).to receive(:top?).and_return(false) }

          it 'returns #border_top' do
            expect(coords.padding_top).to eq(23)
          end
        end

        context 'with a top border' do
          before { allow(border).to receive(:top?).and_return(true) }

          it 'returns #border_top plus one' do
            expect(coords.padding_top).to eq(24)
          end
        end
      end

      describe '#content_top' do
        before { allow(border).to receive(:top?).and_return(true) }

        it 'returns #border_top plus the top padding' do
          expect(coords.content_top).to eq(27)
        end

        context 'when row_index > 0' do
          it 'returns #border_topt plus top padding plus row_index grid_heights' do
            # content_top (26) + row_index (2) * grid_height (15)
            expect(coords.content_top(2)).to eq(57)
          end
        end
      end

      describe '#grid_height' do
        before { allow(border).to receive(:inner_horiz?).and_return(true) }

        it 'returns the height of the content plus top/bottom padding plus one' do
          expect(coords.grid_height).to eq(15)
        end
      end

      describe '#inner_grid_height' do
        it 'returns the height of the content plus top/bottom padding' do
          expect(coords.inner_grid_height).to eq(14)
        end
      end
    end
  end
end
