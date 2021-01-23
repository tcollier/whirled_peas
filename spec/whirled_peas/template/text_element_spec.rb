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

        it 'sets a string as the entry in the content array' do
          element.content = 'Hello'
          expect(element.content).to eq(['Hello'])
        end

        it 'sets a float as the entry in the content array' do
          element.content = 3.14
          expect(element.content).to eq(['3.14'])
        end

        context 'when the value cannot be converted to a string' do
          it 'raises an ArgumentError' do
            expect do
              element.content = Object.new
            end.to raise_error(ArgumentError, 'Unsupported type for TextElement: Object')
          end
        end

        context 'when title_font is set' do
          before do
            allow(Utils::TitleFont)
              .to receive(:to_s)
              .with('3.14', :default)
              .and_return("BIG\nPI!")
            allow(settings).to receive(:title_font).and_return(:default)
          end

          it 'sets mutliple lines in in the content array' do
            element.content = 3.14
            expect(element.content).to eq(['BIG', 'PI!'])
          end
        end
      end

      describe '#dimensions' do
        subject(:element) { described_class.new('Subject', settings) }

        let(:settings) { instance_double(Settings::TextSettings, title_font: nil) }

        it 'returns num_cols/num_rows = 1' do
          element.content = 'Hello'
          dimensions = element.dimensions
          expect(dimensions.num_cols).to eq(1)
          expect(dimensions.num_rows).to eq(1)
        end

        it 'sets proper dimensions for a plain string' do
          element.content = 'Hello'
          dimensions = element.dimensions
          expect(dimensions.content_width).to eq(5)
          expect(dimensions.content_height).to eq(1)
          expect(dimensions.outer_width).to eq(5)
          expect(dimensions.outer_height).to eq(1)
        end

        context 'when title_font is set' do
          before do
            allow(Utils::TitleFont)
              .to receive(:to_s)
              .with('3.14', :default)
              .and_return("BIG\nPI!")
            allow(settings).to receive(:title_font).and_return(:default)
          end

          it 'sets proper dimensions for the multi-line string' do
            element.content = 3.14
            dimensions = element.dimensions
            expect(dimensions.content_width).to eq(3)
            expect(dimensions.content_height).to eq(2)
            expect(dimensions.outer_width).to eq(3)
            expect(dimensions.outer_height).to eq(2)
          end
        end
      end
    end
  end
end
