require 'whirled_peas/graphics/text_painter'
require 'whirled_peas/settings/text_settings'
require 'whirled_peas/utils/title_font'

module WhirledPeas
  module Graphics
    RSpec.describe TextPainter do
      describe '#dimensions' do
        subject(:painter) { described_class.new('Subject', settings) }

        let(:settings) do
          instance_double(Settings::TextSettings, title_font: nil, width: nil, height: nil)
        end

        it 'has an outer_height of the content' do
          painter.content = 'Hello'
          expect(painter.dimensions.outer_width).to eq(5)
        end

        it 'has an outer_width of the content length' do
          painter.content = 'Hello'
          expect(painter.dimensions.outer_height).to eq(1)
        end

        context 'with a multi-line string' do
          it 'has an outer_height of the longest line' do
            painter.content = "12345678\n12"
            expect(painter.dimensions.outer_width).to eq(8)
          end

          it 'has an outer_width equal to the number of lines' do
            painter.content = "foo\nbar\nbaz"
            expect(painter.dimensions.outer_height).to eq(3)
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

          it 'sets the outer dimensions of the multiline string' do
            painter.content = 'Hello'
            expect(painter.dimensions.outer_width).to eq(3)
            expect(painter.dimensions.outer_height).to eq(2)
          end
        end
      end
    end
  end
end
