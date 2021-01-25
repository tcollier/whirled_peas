require 'whirled_peas/graphics/canvas'
require 'whirled_peas/utils/formatted_string'

module WhirledPeas
  module Graphics
    RSpec.describe Canvas do
      def unpack(left, top, fstring)
        return [left, top, fstring]
      end

      describe '#child' do
        subject(:canvas) { described_class.new(3, 2, 7, 5, 0, 0) }

        let(:any_left) { canvas.left }
        let(:any_top) { canvas.top }
        let(:any_width) { 4 }
        let(:any_height) { 3 }

        it 'returns a canvas that fits exactly in the parent' do
          expect(canvas.child(3, 2, 7, 5)).to eq(canvas)
        end

        it 'trims off anything to the left of the parent' do
          expect(canvas.child(2, any_top, 4, any_height))
            .to eq(described_class.new(3, any_top, 3, any_height, 2, any_top))
        end

        it 'trims off anything above the parent' do
          expect(canvas.child(any_left, 1, any_width, 2))
            .to eq(described_class.new(any_left, 2, any_width, 1, any_left, 1))
        end

        it 'trims off anything to the right of the parent' do
          expect(canvas.child(9, any_top, 2, any_height))
            .to eq(described_class.new(9, any_top, 1, any_height, 9, any_top))
        end

        it 'trims off anything below the parent' do
          expect(canvas.child(any_left, 6, any_width, 2))
            .to eq(described_class.new(any_left, 6, any_width, 1, any_left, 6))
        end

        it 'returns an unwritable canvas if there is no overlap' do
          expect(canvas.child(10, 7, 10, 10).writable?).to eq(false)
        end
      end

      describe '#stroke' do
        subject(:canvas) { described_class.new(8, 5, 4, 1, 0, 0) }

        let(:any_left) { canvas.left }
        let(:any_top) { canvas.top }
        let(:any_string) { '1234' }

        it 'yields left/top/fstring' do
          left, top, fstring = canvas.stroke(8, 5, '1234', [9, 10], &method(:unpack))
          expect(left).to eq(8)
          expect(top).to eq(5)
          expect(fstring).to eq(Utils::FormattedString.new('1234', [9, 10]))
        end

        it 'uses the whole stroke when it fits in the middle' do
          left, _, fstring = canvas.stroke(9, any_top, '23', &method(:unpack))
          expect(left).to eq(9)
          expect(fstring).to eq('23')
        end

        it 'only uses the first part when the stroke goes past end' do
          left, _, fstring = canvas.stroke(8, any_top, '12345', &method(:unpack))
          expect(left).to eq(8)
          expect(fstring).to eq('1234')
        end

        it 'only uses the first part when the stroke starts in the middle' do
          left, _, fstring = canvas.stroke(10, any_top, '345', &method(:unpack))
          expect(left).to eq(10)
          expect(fstring).to eq('34')
        end

        it 'only uses the last part with the stroke starts before begining' do
          left, _, fstring = canvas.stroke(7, any_top, '012', &method(:unpack))
          expect(left).to eq(8)
          expect(fstring).to eq('12')
        end

        it 'only uses the middle part with the stroke is too long' do
          left, _, fstring = canvas.stroke(7, any_top, '012345', &method(:unpack))
          expect(left).to eq(8)
          expect(fstring).to eq('1234')
        end

        it 'returns a blank fstring when the stroke is entirely to the left' do
          _, _, fstring = canvas.stroke(7, any_top, '0', &method(:unpack))
          expect(fstring.blank?).to eq(true)
        end

        it 'returns a blank fstring when the stroke is entirely to the right' do
          _, _, fstring = canvas.stroke(12, any_top, '5', &method(:unpack))
          expect(fstring.blank?).to eq(true)
        end

        it 'returns a blank fstring when the stroke is entirely too low' do
          _, _, fstring = canvas.stroke(any_left, 4, any_string, &method(:unpack))
          expect(fstring.blank?).to eq(true)
        end

        it 'returns a blank fstring when the stroke is entirely too high' do
          _, _, fstring = canvas.stroke(any_left, 6, any_string, &method(:unpack))
          expect(fstring.blank?).to eq(true)
        end
      end
    end
  end
end
