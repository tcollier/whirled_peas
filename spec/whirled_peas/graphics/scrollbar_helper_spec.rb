require 'whirled_peas/graphics/scrollbar_helper'

module WhirledPeas
  module Graphics
    RSpec.describe ScrollbarHelper do
      shared_examples_for 'a scrollbar character' do |method, chars|
        it 'returns the gutter when there is no content' do
          4.times do |curr_index|
            expect(described_class.send(method, 0, 4, 0, curr_index)).to eq(chars[0])
          end
        end

        it 'returns the gutter when viewport is size = 0' do
          expect(described_class.send(method, 4, 0, 0, 0)).to eq(chars[0])
        end

        it 'returns the gutter when the viewport is as big as the content' do
          4.times do |curr_index|
            expect(described_class.send(method, 4, 4, 0, curr_index)).to eq(chars[0])
          end
        end

        it 'returns the full scroll char at the start of a short list' do
          expect(described_class.send(method, 26, 10, 0, 0)).to eq(chars[3])
        end

        it 'returns the full scroll char at the end of a short list' do
          expect(described_class.send(method, 26, 10, 15, 9)).to eq(chars[3])
        end

        it 'returns the first half scrollbar at the start of long list' do
          expect(described_class.send(method, 10000, 4, 0, 0)).to eq(chars[2])
        end

        it 'returns the second half scrollbar at the end of long list' do
          expect(described_class.send(method, 10000, 4, 9995, 3)).to eq(chars[1])
        end

        it 'returns the expected scrollbar' do
          [chars[0], chars[1], chars[3], chars[2]].each.with_index do |expected_char, curr_index|
            expect(described_class.send(method, 8, 4, 3, curr_index)).to eq(expected_char)
          end
        end
      end

      describe '.horiz_char' do
        it_behaves_like 'a scrollbar character', :horiz_char, ScrollbarHelper::HORIZONTAL
      end

      describe '.vert_char' do
        it_behaves_like 'a scrollbar character', :vert_char, ScrollbarHelper::VERTICAL
      end
    end
  end
end
