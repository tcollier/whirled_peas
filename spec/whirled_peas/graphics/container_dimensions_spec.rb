require 'whirled_peas/graphics/container_dimensions'
require 'whirled_peas/settings/container_settings'

module WhirledPeas
  module Graphics
    RSpec.describe ContainerDimensions do
      subject(:dimensions) do
        described_class.new(settings, 7, 3, num_cols, num_rows)
      end

      let(:num_cols) { 1 }
      let(:num_rows) { 1 }
      let(:margin) { Settings::Margin.new }
      let(:border) { Settings::Border.new }
      let(:padding) { Settings::Padding.new }
      let(:settings) do
        instance_double(
          Settings::ContainerSettings,
          margin: margin,
          border: border,
          padding: padding
        )
      end

      describe '#outer_width' do
        it 'returns content_width as the base' do
          expect(dimensions.outer_width).to eq(7)
        end

        context 'when left margin is non zero' do
          before { margin.left = 4 }

          it 'is included in the total' do
            expect(dimensions.outer_width).to eq(11)
          end
        end

        context 'when right margin is non zero' do
          before { margin.right = 5 }

          it 'is included in the total' do
            expect(dimensions.outer_width).to eq(12)
          end
        end

        context 'when left border is set' do
          before { border.left = true }

          it 'adds 1 to the total' do
            expect(dimensions.outer_width).to eq(8)
          end
        end

        context 'when right border is set' do
          before { border.right = true }

          it 'adds 1 to the total' do
            expect(dimensions.outer_width).to eq(8)
          end
        end

        context 'when left padding is non zero' do
          before { padding.left = 4 }

          it 'is included in the total' do
            expect(dimensions.outer_width).to eq(11)
          end
        end

        context 'when right padding is non zero' do
          before { padding.right = 5 }

          it 'is included in the total' do
            expect(dimensions.outer_width).to eq(12)
          end
        end

        context 'when everything is set' do
          before do
            margin.left = 3
            margin.right = 5
            border.left = true
            border.right = true
            padding.left = 7
            padding.right = 9
          end

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
          before { margin.top = 4 }

          it 'is included in the total' do
            expect(dimensions.outer_height).to eq(7)
          end
        end

        context 'when bottom margin is non zero' do
          before { margin.bottom = 5 }

          it 'is included in the total' do
            expect(dimensions.outer_height).to eq(8)
          end
        end

        context 'when top border is set' do
          before { border.top = true }

          it 'adds 1 to the total' do
            expect(dimensions.outer_height).to eq(4)
          end
        end

        context 'when bottom border is set' do
          before { border.bottom = true }

          it 'adds 1 to the total' do
            expect(dimensions.outer_height).to eq(4)
          end
        end

        context 'when top padding is non zero' do
          before { padding.top = 4 }

          it 'is included in the total' do
            expect(dimensions.outer_height).to eq(7)
          end
        end

        context 'when bottom padding is non zero' do
          before { padding.bottom = 5 }

          it 'is included in the total' do
            expect(dimensions.outer_height).to eq(8)
          end
        end

        context 'when everything is set' do
          before do
            margin.top = 3
            margin.bottom = 5
            border.top = true
            border.bottom = true
            padding.top = 7
            padding.bottom = 9
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
            before { margin.left = 4 }

            it 'is included once in the total' do
              expect(dimensions.outer_width).to eq(25)
            end
          end

          context 'when right margin is non zero' do
            before { margin.right = 5 }

            it 'is included once in the total' do
              expect(dimensions.outer_width).to eq(26)
            end
          end

          context 'when left border is set' do
            before { border.left = true }

            it 'adds 1 to the total' do
              expect(dimensions.outer_width).to eq(22)
            end
          end

          context 'when inner vertical border is set' do
            before { border.inner_vert = true }

            it 'adds num_col - 1 to the total' do
              expect(dimensions.outer_width).to eq(23)
            end
          end

          context 'when right border is set' do
            before { border.right = true }

            it 'adds 1 to the total' do
              expect(dimensions.outer_width).to eq(22)
            end
          end

          context 'when left padding is non zero' do
            before { padding.left = 4 }

            it 'is included num_col times in the total' do
              expect(dimensions.outer_width).to eq(33)
            end
          end

          context 'when right padding is non zero' do
            before { padding.right = 5 }

            it 'is included num_col times in the total' do
              expect(dimensions.outer_width).to eq(36)
            end
          end

          context 'when everything is set' do
            before do
              margin.left = 3
              margin.right = 5
              border.left = true
              border.inner_vert = true
              border.right = true
              padding.left = 7
              padding.right = 9
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
            before { margin.top = 4 }

            it 'is included once in the total' do
              expect(dimensions.outer_height).to eq(16)
            end
          end

          context 'when bottom margin is non zero' do
            before { margin.bottom = 5 }

            it 'is included once in the total' do
              expect(dimensions.outer_height).to eq(17)
            end
          end

          context 'when top border is set' do
            before { border.top = true }

            it 'adds 1 to the total' do
              expect(dimensions.outer_height).to eq(13)
            end
          end

          context 'when bottom inner horizontal is set' do
            before { border.inner_horiz = true }

            it 'adds num_rows - 1 to the total' do
              expect(dimensions.outer_height).to eq(15)
            end
          end

          context 'when bottom border is set' do
            before { border.bottom = true }

            it 'adds 1 to the total' do
              expect(dimensions.outer_height).to eq(13)
            end
          end

          context 'when top padding is non zero' do
            before { padding.top = 4 }

            it 'is included num_col times in the total' do
              expect(dimensions.outer_height).to eq(28)
            end
          end

          context 'when bottom padding is non zero' do
            before { padding.bottom = 5 }

            it 'is included num_col times in the total' do
              expect(dimensions.outer_height).to eq(32)
            end
          end

          context 'when everything is set' do
            before do
              margin.top = 3
              margin.bottom = 5
              border.top = true
              border.inner_horiz = true
              border.bottom = true
              padding.top = 7
              padding.bottom = 9
            end

            it 'is includes it all in the total' do
              expect(dimensions.outer_height).to eq(89)
            end
          end
        end
      end
    end
  end
end
