require 'whirled_peas/ui/color'

module WhirledPeas::UI
  RSpec.shared_examples_for 'a Color' do
    describe '.validate!' do
      VALID_SYMBOLS = {
        black: described_class::BLACK,
        white: described_class::WHITE,
        gray: described_class::GRAY,
        red: described_class::RED,
        green: described_class::GREEN,
        yellow: described_class::YELLOW,
        blue: described_class::BLUE,
        magenta: described_class::MAGENTA,
        cyan: described_class::CYAN,
        bright_red: described_class::RED.bright,
        bright_green: described_class::GREEN.bright,
        bright_yellow: described_class::YELLOW.bright,
        bright_blue: described_class::BLUE.bright,
        bright_magenta: described_class::MAGENTA.bright,
        bright_cyan: described_class::CYAN.bright,
      }.each_pair do |symbol, color|
        it "validates #{symbol.inspect}" do
          expect(described_class.validate!(symbol)).to eq(color)
        end

        it "validates #{color}" do
          expect(described_class.validate!(color)).to eq(color)
        end
      end

      it 'validates nil' do
        expect(described_class.validate!(nil)).to be_nil
      end

      it 'raises an error for an unrecognized symbol' do
        expect do
          described_class.validate!(:purplish)
        end.to raise_error(ArgumentError, /Unsupported [\w]+Color: :purplish/)
      end

      it 'raises an error for a double bright symbol' do
        expect do
          described_class.validate!(:bright_bright_green)
        end.to raise_error(ArgumentError, /Unsupported [\w]+Color: :bright_bright_green/)
      end
    end

    describe '#bright' do
      it 'returns the bright version of a standard color' do
        expect(described_class.new(12).bright).to eq(described_class.new(72, true))
      end

      it 'returns itself if already bright' do
        expect(described_class.new(65, true).bright).to eq(described_class.new(65, true))
      end
    end
  end

  RSpec.describe TextColor do
    it_behaves_like 'a Color'
  end

  RSpec.describe BgColor do
    it_behaves_like 'a Color'
  end
end
