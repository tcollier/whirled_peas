require 'whirled_peas/graphics/text_painter'
require 'whirled_peas/settings/text_settings'
require 'whirled_peas/utils/title_font'

module WhirledPeas
  module Graphics
    RSpec.describe TextPainter do
      describe '#content' do
        subject(:painter) { described_class.new('Subject', settings) }

        let(:settings) do
          instance_double(Settings::TextSettings, title_font: nil)
        end

        it 'places the content in an array' do
          painter.content = 'Hello'
          expect(painter.content).to eq(['Hello'])
        end

        context 'with a multi-line string' do
          it 'splits the string on new lines' do
            painter.content = "first\nsecond"
            expect(painter.content).to eq(['first', 'second'])
          end
        end

        context 'when title_font is set' do
          before do
            allow(Utils::TitleFont)
              .to receive(:to_s)
              .with('Hello', :default)
              .and_return("BIG\nHI!")
            allow(settings).to receive(:title_font).and_return(:default)
          end

          it 'sets mutliple lines in in the content array' do
            painter.content = 'Hello'
            expect(painter.content).to eq(['BIG', 'HI!'])
          end
        end
      end

      describe '#dimensions' do
        subject(:painter) { described_class.new('Subject', settings) }

        let(:settings) { instance_double(Settings::TextSettings, title_font: nil) }

        it 'sets proper dimensions for a plain string' do
          painter.content = 'Hello'
          dimensions = painter.dimensions
          expect(dimensions.outer_width).to eq(5)
          expect(dimensions.outer_height).to eq(1)
        end

        context 'when title_font is set' do
          before do
            allow(Utils::TitleFont)
              .to receive(:to_s)
              .with('Hello', :default)
              .and_return("BIG\nHI!")
            allow(settings).to receive(:title_font).and_return(:default)
          end

          it 'sets proper dimensions for the multi-line string' do
            painter.content = 'Hello'
            dimensions = painter.dimensions
            expect(dimensions.outer_width).to eq(3)
            expect(dimensions.outer_height).to eq(2)
          end
        end
      end
    end
  end
end
