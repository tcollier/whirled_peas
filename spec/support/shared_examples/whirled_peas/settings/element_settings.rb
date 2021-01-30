require 'whirled_peas/settings/alignment'
require 'whirled_peas/settings/color'
require 'whirled_peas/settings/theme'

module WhirledPeas
  module Settings
    RSpec.shared_examples_for 'an ElementSettings' do
      context 'validated attributes' do
        subject(:settings) { described_class.new(theme) }

        let(:theme) { instance_double(Settings::Theme) }

        specify do
          expect { subject.bg_color = :garbage }.to raise_error(ArgumentError, 'Unsupported BgColor: :garbage')
        end

        specify do
          expect { subject.color = :garbage }.to raise_error(ArgumentError, 'Unsupported TextColor: :garbage')
        end
      end

      context 'inherited attributes' do
        let(:parent) { ElementSettings.new(theme) }

        let(:theme) { instance_double(Settings::Theme) }

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
