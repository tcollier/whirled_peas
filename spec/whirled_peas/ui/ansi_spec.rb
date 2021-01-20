module WhirledPeas::UI
  module Ansi
    RSpec.describe Ansi do
      describe '.first' do
        it 'returns a full string that is short enough' do
          expect(described_class.first('hi', 2)).to eq('hi')
        end

        it 'truncates a long string with no formatting' do
          expect(described_class.first('hello', 2)).to eq('he')
        end

        it 'truncates formatting off the end' do
          expect(described_class.first("he\033[21mllo\033[0m", 2)).to eq('he')
        end

        it 'closes formatting when substring is not closed' do
          expect(described_class.first("h\033[21mello\033[0m", 2)).to eq("h\033[21me\033[0m")
        end

        it 'preserves closing when substring is closed' do
          expect(described_class.first("h\033[21me\033[0mllo", 2)).to eq("h\033[21me\033[0m")
        end
      end
    end
  end
end
