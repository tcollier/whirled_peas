require 'whirled_peas/ui/canvas'

module WhirledPeas
  module UI
    RSpec.describe Canvas do
      describe '#stroke' do
        subject(:canvas) { described_class.new(8, 5, 2, 1) }

        it 'creates a Stroke instance' do
          expect(canvas.stroke(8, 5, 'hi').left).to eq(8)
          expect(canvas.stroke(8, 5, 'hi').top).to eq(5)
          expect(canvas.stroke(8, 5, 'hi').chars).to eq('hi')
        end

        it 'only uses the first part when the stroke goes past end' do
          expect(canvas.stroke(9, 5, '12').left).to eq(9)
          expect(canvas.stroke(9, 5, '12').chars).to eq('1')
        end

        it 'only uses the last part with the stroke starts before begining' do
          expect(canvas.stroke(7, 5, '12').left).to eq(8)
          expect(canvas.stroke(7, 5, '12').chars).to eq('2')
        end

        it 'only uses the middle part with the stroke is too long' do
          expect(canvas.stroke(7, 5, '1234').left).to eq(8)
          expect(canvas.stroke(7, 5, '1234').chars).to eq('23')
        end

        it 'returns a null stroke when the stroke is entirely to the left' do
          expect(canvas.stroke(6, 5, 'hi').chars).to be_nil
        end

        it 'returns a null stroke when the stroke is entirely to the right' do
          expect(canvas.stroke(10, 5, 'hi').chars).to be_nil
        end

        it 'returns a null stroke when the stroke is entirely too low' do
          expect(canvas.stroke(8, 4, 'hi').chars).to be_nil
        end

        it 'returns a null stroke when the stroke is entirely too high' do
          expect(canvas.stroke(8, 6, 'hi').chars).to be_nil
        end
      end
    end
  end
end
