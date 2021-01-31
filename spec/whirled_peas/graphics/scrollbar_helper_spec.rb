require 'whirled_peas/graphics/scrollbar_helper'

module WhirledPeas
  module Graphics
    RSpec.describe ScrollbarHelper do
      shared_examples_for 'a scrollbar character' do |method, chars|
        def expected(chars, *indexes)
          indexes.map { |index| chars[index] }
        end

        it 'returns the gutter when there is no content' do
          expect(described_class.send(method, 0, 4, 0)).to eq(expected(chars, 0, 0, 0, 0))
        end

        it 'returns an empty array when viewport is size = 0' do
          expect(described_class.send(method, 4, 0, 0)).to eq([])
        end

        it 'returns the gutter when the viewport is as big as the content' do
          expect(described_class.send(method, 4, 4, 0)).to eq(expected(chars, 0, 0, 0, 0))
        end

        it 'returns the full scroll char at the start of a short list' do
          expect(described_class.send(method, 16, 4, 0)).to eq(expected(chars, 3, 0, 0, 0))
        end

        it 'returns the full scroll char at the end of a short list' do
          expect(described_class.send(method, 16, 4, 11)).to eq(expected(chars, 0, 0, 0, 3))
        end

        it 'returns the first half scrollbar at the start of long list' do
          expect(described_class.send(method, 10000, 4, 0)).to eq(expected(chars, 2, 0, 0, 0))
        end

        it 'returns the second half scrollbar at the end of long list' do
          expect(described_class.send(method, 10000, 4, 9995)).to eq(expected(chars, 0, 0, 0, 1))
        end

        it 'returns the expected scrollbar' do
          expect(described_class.send(method, 8, 4, 3)).to eq(expected(chars, 0, 1, 3, 2))
        end
      end

      describe '.horiz_char' do
        it_behaves_like 'a scrollbar character', :horiz, ScrollbarHelper::HORIZONTAL
      end

      describe '.vert_char' do
        it_behaves_like 'a scrollbar character', :vert, ScrollbarHelper::VERTICAL
      end
    end
  end
end
