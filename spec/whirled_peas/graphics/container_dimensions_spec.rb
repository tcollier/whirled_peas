require 'whirled_peas/graphics/container_dimensions'
require 'whirled_peas/settings/border'
require 'whirled_peas/settings/container_settings'
require 'whirled_peas/settings/margin'
require 'whirled_peas/settings/padding'
require 'whirled_peas/settings/scrollbar'
require 'whirled_peas/settings/sizing'

module WhirledPeas
  module Graphics
    RSpec.describe ContainerDimensions do
      subject(:dimensions) do
        described_class.new(settings, 7, 3, num_cols, num_rows)
      end

      let(:num_cols) { 1 }
      let(:num_rows) { 1 }
      let(:margin) do
        instance_double(Settings::Margin, left: 0, top: 0, right: 0, bottom: 0)
      end
      let(:border) do
        instance_double(
          Settings::Border,
          left?: false,
          top?: false,
          right?: false,
          bottom?: false,
          inner_horiz?: false,
          inner_vert?: false
        )
      end
      let(:padding) do
        instance_double(Settings::Padding, left: 0, top: 0, right: 0, bottom: 0)
      end
      let(:scrollbar) { instance_double(Settings::Scrollbar, horiz?: false, vert?: false) }
      let(:settings) do
        instance_double(
          Settings::ContainerSettings,
          margin: margin,
          border: border,
          padding: padding,
          scrollbar: scrollbar,
          border_sizing?: false,
          width: nil,
          height: nil
        )
      end

      describe '#content_width' do
        context 'when settings.width is not set' do
          it 'returns the passed in content_width' do
            expect(dimensions.content_width).to eq(7)
          end
        end

        context 'when settings.width is set with :content sizing' do
          before { allow(settings).to receive(:width).and_return(25) }

          it 'returns settings.width' do
            expect(dimensions.content_width).to eq(25)
          end
        end

        context 'when settings.width is set with :border sizing' do
          before do
            allow(settings).to receive(:border_sizing?).and_return(true)
            allow(settings).to receive(:width).and_return(25)
            allow(border).to receive(:left?).and_return(true)
            allow(border).to receive(:right?).and_return(true)
            allow(scrollbar).to receive(:vert?).and_return(true)
            allow(padding).to receive(:left).and_return(3)
            allow(padding).to receive(:right).and_return(4)
          end

          it 'returns settings.width minus border/padding/scrollbar widths' do
            expect(dimensions.content_width).to eq(15)
          end
        end
      end

      describe '#content_height' do
        context 'when settings.width is not set' do
          it 'returns the passed in content_height' do
            expect(dimensions.content_height).to eq(3)
          end
        end

        context 'when settings.height is set with :content sizing' do
          before { allow(settings).to receive(:height).and_return(7) }

          it 'returns settings.height' do
            expect(dimensions.content_height).to eq(7)
          end
        end

        context 'when settings.height is set with :border sizing' do
          before do
            allow(settings).to receive(:border_sizing?).and_return(true)
            allow(settings).to receive(:height).and_return(7)
            allow(border).to receive(:top?).and_return(true)
            allow(border).to receive(:bottom?).and_return(true)
            allow(scrollbar).to receive(:horiz?).and_return(true)
            allow(padding).to receive(:top).and_return(1)
            allow(padding).to receive(:bottom).and_return(2)
          end

          it 'returns settings.height minus border/padding/scrollbar heights' do
            expect(dimensions.content_height).to eq(1)
          end
        end
      end

      describe '#outer_width' do
        it 'returns content_width as the base' do
          expect(dimensions.outer_width).to eq(7)
        end

        context 'when left margin is non zero' do
          before { allow(margin).to receive(:left).and_return(4) }

          it 'is included in the total' do
            expect(dimensions.outer_width).to eq(11)
          end
        end

        context 'when right margin is non zero' do
          before { allow(margin).to receive(:right).and_return(5) }

          it 'is included in the total' do
            expect(dimensions.outer_width).to eq(12)
          end
        end

        context 'when left border is set' do
          before { allow(border).to receive(:left?).and_return(true) }

          it 'adds 1 to the total' do
            expect(dimensions.outer_width).to eq(8)
          end
        end

        context 'when right border is set' do
          before { allow(border).to receive(:right?).and_return(true) }

          it 'adds 1 to the total' do
            expect(dimensions.outer_width).to eq(8)
          end
        end

        context 'when left padding is non zero' do
          before { allow(padding).to receive(:left).and_return(4) }

          it 'is included in the total' do
            expect(dimensions.outer_width).to eq(11)
          end
        end

        context 'when right padding is non zero' do
          before { allow(padding).to receive(:right).and_return(5) }

          it 'is included in the total' do
            expect(dimensions.outer_width).to eq(12)
          end
        end
      end

      context 'when everything is set' do
        before do
          allow(margin).to receive(:left).and_return(3)
          allow(margin).to receive(:right).and_return(5)
          allow(border).to receive(:left?).and_return(true)
          allow(border).to receive(:inner_vert?).and_return(true)
          allow(border).to receive(:right?).and_return(true)
          allow(padding).to receive(:left).and_return(7)
          allow(padding).to receive(:right).and_return(9)
        end

        describe '#grid_width' do
          it 'returns the width of the content plus left/right padding plus one' do
            expect(dimensions.grid_width).to eq(24)
          end
        end

        describe '#inner_grid_width' do
          it 'returns the width of the content plus left/right padding' do
            expect(dimensions.inner_grid_width).to eq(23)
          end
        end

        describe '#outer_width' do
          it 'is includes it all in the total' do
            expect(dimensions.outer_width).to eq(33)
          end
        end
      end

      describe '#outer_height' do
        it 'returns content_height as the base' do
          expect(dimensions.outer_height).to eq(3)
        end

        context 'when top margin is non zero' do
          before { allow(margin).to receive(:top).and_return(4) }

          it 'is included in the total' do
            expect(dimensions.outer_height).to eq(7)
          end
        end

        context 'when bottom margin is non zero' do
          before { allow(margin).to receive(:bottom).and_return(5) }

          it 'is included in the total' do
            expect(dimensions.outer_height).to eq(8)
          end
        end

        context 'when top border is set' do
          before { allow(border).to receive(:top?).and_return(true) }

          it 'adds 1 to the total' do
            expect(dimensions.outer_height).to eq(4)
          end
        end

        context 'when bottom border is set' do
          before { allow(border).to receive(:bottom?).and_return(true) }

          it 'adds 1 to the total' do
            expect(dimensions.outer_height).to eq(4)
          end
        end

        context 'when top padding is non zero' do
          before { allow(padding).to receive(:top).and_return(4) }

          it 'is included in the total' do
            expect(dimensions.outer_height).to eq(7)
          end
        end

        context 'when bottom padding is non zero' do
          before { allow(padding).to receive(:bottom).and_return(5) }

          it 'is included in the total' do
            expect(dimensions.outer_height).to eq(8)
          end
        end

        context 'when everything is set' do
          before do
            allow(margin).to receive(:top).and_return(3)
            allow(margin).to receive(:bottom).and_return(5)
            allow(border).to receive(:top?).and_return(true)
            allow(border).to receive(:bottom?).and_return(true)
            allow(padding).to receive(:top).and_return(7)
            allow(padding).to receive(:bottom).and_return(9)
          end

          it 'is includes it all in the total' do
            expect(dimensions.outer_height).to eq(29)
          end
        end
      end

      context 'with multiple row/columns' do
        let(:num_cols) { 3 }
        let(:num_rows) { 4 }

        describe '#outer_width' do
          it 'returns num_cols * content_width as base' do
            expect(dimensions.outer_width).to eq(21)
          end

          context 'when left margin is non zero' do
            before { allow(margin).to receive(:left).and_return(4) }

            it 'is included once in the total' do
              expect(dimensions.outer_width).to eq(25)
            end
          end

          context 'when right margin is non zero' do
            before { allow(margin).to receive(:right).and_return(5) }

            it 'is included once in the total' do
              expect(dimensions.outer_width).to eq(26)
            end
          end

          context 'when left border is set' do
            before { allow(border).to receive(:left?).and_return(true) }

            it 'adds 1 to the total' do
              expect(dimensions.outer_width).to eq(22)
            end
          end

          context 'when inner vertical border is set' do
            before { allow(border).to receive(:inner_vert?).and_return(true) }

            it 'adds num_col - 1 to the total' do
              expect(dimensions.outer_width).to eq(23)
            end
          end

          context 'when right border is set' do
            before { allow(border).to receive(:right?).and_return(true) }

            it 'adds 1 to the total' do
              expect(dimensions.outer_width).to eq(22)
            end
          end

          context 'when left padding is non zero' do
            before { allow(padding).to receive(:left).and_return(4) }

            it 'is included num_col times in the total' do
              expect(dimensions.outer_width).to eq(33)
            end
          end

          context 'when right padding is non zero' do
            before { allow(padding).to receive(:right).and_return(5) }

            it 'is included num_col times in the total' do
              expect(dimensions.outer_width).to eq(36)
            end
          end

          context 'when everything is set' do
            before do
              allow(margin).to receive(:left).and_return(3)
              allow(margin).to receive(:right).and_return(5)
              allow(border).to receive(:left?).and_return(true)
              allow(border).to receive(:inner_vert?).and_return(true)
              allow(border).to receive(:right?).and_return(true)
              allow(padding).to receive(:left).and_return(7)
              allow(padding).to receive(:right).and_return(9)
            end

            it 'is includes it all in the total' do
              expect(dimensions.outer_width).to eq(81)
            end
          end
        end

        context '#outer_height' do
          it 'returns num_rows * content_height as base outer_height' do
            expect(dimensions.outer_height).to eq(12)
          end

          context 'when top margin is non zero' do
            before { allow(margin).to receive(:top).and_return(4) }

            it 'is included once in the total' do
              expect(dimensions.outer_height).to eq(16)
            end
          end

          context 'when bottom margin is non zero' do
            before { allow(margin).to receive(:bottom).and_return(5) }

            it 'is included once in the total' do
              expect(dimensions.outer_height).to eq(17)
            end
          end

          context 'when top border is set' do
            before { allow(border).to receive(:top?).and_return(true) }

            it 'adds 1 to the total' do
              expect(dimensions.outer_height).to eq(13)
            end
          end

          context 'when bottom inner horizontal is set' do
            before { allow(border).to receive(:inner_horiz?).and_return(true) }

            it 'adds num_rows - 1 to the total' do
              expect(dimensions.outer_height).to eq(15)
            end
          end

          context 'when bottom border is set' do
            before { allow(border).to receive(:bottom?).and_return(true) }

            it 'adds 1 to the total' do
              expect(dimensions.outer_height).to eq(13)
            end
          end

          context 'when top padding is non zero' do
            before { allow(padding).to receive(:top).and_return(4) }

            it 'is included num_col times in the total' do
              expect(dimensions.outer_height).to eq(28)
            end
          end

          context 'when bottom padding is non zero' do
            before { allow(padding).to receive(:bottom).and_return(5) }

            it 'is included num_col times in the total' do
              expect(dimensions.outer_height).to eq(32)
            end
          end
        end

        context 'when everything is set' do
          before do
            allow(margin).to receive(:top).and_return(3)
            allow(margin).to receive(:bottom).and_return(5)
            allow(border).to receive(:top?).and_return(true)
            allow(border).to receive(:inner_horiz?).and_return(true)
            allow(border).to receive(:bottom?).and_return(true)
            allow(padding).to receive(:top).and_return(7)
            allow(padding).to receive(:bottom).and_return(9)
          end

          describe '#grid_height' do
            before { allow(border).to receive(:inner_horiz?).and_return(true) }

            it 'returns the height of the content plus top/bottom padding plus one' do
              expect(dimensions.grid_height).to eq(20)
            end
          end

          describe '#inner_grid_height' do
            it 'returns the height of the content plus top/bottom padding' do
              expect(dimensions.inner_grid_height).to eq(19)
            end
          end

          describe '#outer_height' do
            it 'is includes it all in the total' do
              expect(dimensions.outer_height).to eq(89)
            end
          end
        end
      end
    end
  end
end
