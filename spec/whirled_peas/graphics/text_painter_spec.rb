require 'whirled_peas/graphics/text_painter'
require 'whirled_peas/settings/text_settings'
require 'whirled_peas/template/text_element'
require 'whirled_peas/utils/title_font'

module WhirledPeas
  module Graphics
    RSpec.describe TextPainter do
      describe '#content' do
        subject(:painter) { described_class.new(element, settings, 'Subject') }

        let(:element) do
          instance_double(Template::TextElement, content: 'Hello', settings: settings)
        end
        let(:settings) do
          instance_double(Settings::TextSettings, title_font: nil)
        end

        it 'places the content in an array' do
          expect(painter.content).to eq(['Hello'])
        end

        context 'with a multi-line string' do
          before { allow(element).to receive(:content).and_return("first\nsecond") }

          it 'splits the string on new lines' do
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
            expect(painter.content).to eq(['BIG', 'HI!'])
          end
        end
      end

      describe '#dimensions' do
        subject(:painter) { described_class.new(element, settings, 'Subject') }

        let(:element) do
          instance_double(Template::TextElement, settings: settings, content: 'Hello')
        end
        let(:settings) { instance_double(Settings::TextSettings, title_font: nil) }

        it 'sets proper dimensions for a plain string' do
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
            dimensions = painter.dimensions
            expect(dimensions.outer_width).to eq(3)
            expect(dimensions.outer_height).to eq(2)
          end
        end
      end
    end
  end
end
