require 'whirled_peas/utils/ansi'

module WhirledPeas
  module Utils
    RSpec.describe Ansi do
      describe '.close_formatting' do
        it 'does nothing to an unformatted string' do
          expect(described_class.close_formatting('hi')).to eq('hi')
        end

        it 'does nothing to a string with closed formatting' do
          expect(described_class.close_formatting("h\033[21mello\033[0m"))
            .to eq("h\033[21mello\033[0m")
        end

        it 'closes formatting for a string with unclosed formatting' do
          expect(described_class.close_formatting("h\033[21mello"))
            .to eq("h\033[21mello\033[0m")
        end

        it 'closes formatting for a complicated string with unclosed formatting' do
          expect(described_class.close_formatting("h\033[21mello\033[0m wo\033[21mrld"))
            .to eq("h\033[21mello\033[0m wo\033[21mrld\033[0m")
        end
      end

      describe '.first' do
        context 'no formatting' do
          it 'returns a full string that is exact length' do
            expect(described_class.substring('hi', 0, 2)).to eq('hi')
          end

          it 'returns a full string that is short enough' do
            expect(described_class.substring('hi', 0, 10)).to eq('hi')
          end

          it 'trims the end of a long string' do
            expect(described_class.substring('hello', 0, 2)).to eq('he')
          end

          it 'trims the start of a long string' do
            expect(described_class.substring('hello', 3, 2)).to eq('lo')
          end

          it 'trims both ends of a long string' do
            expect(described_class.substring('hello', 1, 2)).to eq('el')
          end
        end

        context 'foramtting before start' do
          it 'maintains formatting before start' do
            expect(described_class.substring("h\033[21mello\033[0m", 3, 2)).to eq("\033[21mlo\033[0m")
          end
        end

        context 'foramtting in substring' do
          it 'closes formatting when substring is not closed' do
            expect(described_class.substring("h\033[21mello\033[0m", 0, 2)).to eq("h\033[21me\033[0m")
          end

          it 'preserves closing when substring is closed' do
            expect(described_class.substring("h\033[21me\033[0mllo", 0, 2)).to eq("h\033[21me\033[0m")
          end
        end

        context 'foramtting after end' do
          it 'truncates formatting off the end' do
            expect(described_class.substring("he\033[21mllo\033[0m", 0, 2)).to eq('he')
          end
        end
      end
    end
  end
end
