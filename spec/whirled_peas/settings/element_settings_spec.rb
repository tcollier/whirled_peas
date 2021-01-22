require 'whirled_peas/settings/color'
require 'whirled_peas/settings/element_settings'
require 'whirled_peas/settings/text_align'

module WhirledPeas
  module Settings
    RSpec.shared_examples_for 'an ElementSettings' do
      context 'casting' do
        let(:other) { ElementSettings.new }

        specify do
          other.color = TextColor::GREEN
          expect(described_class.cast(other).color).to eq(TextColor::GREEN)
        end

        specify do
          other.bg_color = BgColor::GREEN
          expect(described_class.cast(other).bg_color).to eq(BgColor::GREEN)
        end

        specify do
          other.bold = true
          expect(described_class.cast(other).bold?).to eq(true)
        end

        specify do
          other.underline = true
          expect(described_class.cast(other).underline?).to eq(true)
        end

        specify do
          other.width = 99
          expect(described_class.cast(other).width).to eq(99)
        end

        specify do
          other.align = TextAlign::CENTER
          expect(described_class.cast(other).align).to eq(TextAlign::CENTER)
        end
      end

      context 'inherited settings' do
        let(:parent) { ElementSettings.new }

        specify do
          parent.color = TextColor::GREEN
          expect(described_class.inherit(parent).color).to eq(TextColor::GREEN)
        end

        specify do
          parent.bg_color = BgColor::GREEN
          expect(described_class.inherit(parent).bg_color).to eq(BgColor::GREEN)
        end

        specify do
          parent.align = TextAlign::CENTER
          expect(described_class.inherit(parent).align).to eq(TextAlign::CENTER)
        end
      end

      context 'non-inherited setting' do
        let(:parent) { ElementSettings.new }

        specify do
          parent.bold = true
          expect(described_class.inherit(parent).bold?).to eq(false)
        end

        specify do
          parent.underline = true
          expect(described_class.inherit(parent).underline?).to eq(false)
        end

        specify do
          parent.width = 99
          expect(described_class.inherit(parent).width).to be_nil
        end
      end
    end
  end
end
