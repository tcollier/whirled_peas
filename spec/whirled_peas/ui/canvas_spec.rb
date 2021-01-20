require 'whirled_peas/ui/canvas'

module WhirledPeas::UI
  RSpec.describe Canvas do
    describe '#stroke' do
      subject(:canvas) { described_class.new(8, 5, 2, 1) }

      it 'creates a Stroke instance' do
        expect(canvas.stroke(8, 5, 'hi')).to eq(Stroke.new(8, 5, 'hi'))
      end

      it 'only uses the first part when the stroke goes past end' do
        expect(canvas.stroke(9, 5, '12')).to eq(Stroke.new(9, 5, '1'))
      end

      it 'only uses the last part with the stroke starts before begining' do
        expect(canvas.stroke(7, 5, '12')).to eq(Stroke.new(8, 5, '2'))
      end

      it 'only uses the middle part with the stroke is too long' do
        expect(canvas.stroke(7, 5, '1234')).to eq(Stroke.new(8, 5, '23'))
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