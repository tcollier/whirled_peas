require 'whirled_peas/settings/color'
require 'whirled_peas/settings/text_align'

module WhirledPeas
  module Settings
    RSpec.shared_examples_for 'an ElementSettings' do
      context 'inherited attributes' do
        let(:parent) { ElementSettings.new }

        specify do
          parent.bg_color = BgColor::GREEN
          expect(described_class.inherit(parent).bg_color).to eq(BgColor::GREEN)
        end

        specify do
          parent.bold = true
          expect(described_class.inherit(parent).bold?).to eq(true)
        end

        specify do
          parent.color = TextColor::GREEN
          expect(described_class.inherit(parent).color).to eq(TextColor::GREEN)
        end

        specify do
          parent.underline = true
          expect(described_class.inherit(parent).underline?).to eq(true)
        end
      end
    end
  end
end
