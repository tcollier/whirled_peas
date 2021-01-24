require 'whirled_peas/settings/text_settings'
require 'whirled_peas/template/text_element'
require 'whirled_peas/utils/title_font'

module WhirledPeas
  module Template
    RSpec.describe TextElement do
      describe '.stringable?' do
        specify { expect(described_class.stringable?(false)).to eq(true) }
        specify { expect(described_class.stringable?(true)).to eq(true) }
        specify { expect(described_class.stringable?(3.14)).to eq(true) }
        specify { expect(described_class.stringable?(42)).to eq(true) }
        specify { expect(described_class.stringable?(nil)).to eq(true) }
        specify { expect(described_class.stringable?('hi')).to eq(true) }
        specify { expect(described_class.stringable?(:hi)).to eq(true) }

        specify { expect(described_class.stringable?(Object.new)).to eq(false) }
      end

      describe '#content=' do
        subject(:element) { described_class.new('Subject', settings) }

        let(:settings) { instance_double(Settings::TextSettings, title_font: nil) }

        it 'sets a string as is' do
          element.content = 'Hello'
          expect(element.content).to eq('Hello')
        end

        it 'converts a float to a string' do
          element.content = 3.14
          expect(element.content).to eq('3.14')
        end

        context 'when the value cannot be converted to a string' do
          it 'raises an ArgumentError' do
            expect do
              element.content = Object.new
            end.to raise_error(ArgumentError, 'Unsupported type for TextElement: Object')
          end
        end
      end
    end
  end
end
