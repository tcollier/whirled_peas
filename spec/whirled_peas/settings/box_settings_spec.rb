require 'whirled_peas/settings/box_settings'
require 'whirled_peas/settings/theme'

module WhirledPeas
  module Settings
    RSpec.describe BoxSettings do
      it_behaves_like 'a ContainerSettings'

      context 'validated attributes' do
        subject(:settings) { described_class.new(theme) }

        let(:theme) { instance_double(Settings::Theme) }

        specify do
          expect { subject.sizing = :garbage }.to raise_error(ArgumentError, 'Unsupported sizing model: :garbage')
        end
      end

      context 'non-inherited attributes' do
        let(:parent) { ContainerSettings.new(theme) }

        let(:theme) { instance_double(Settings::Theme) }

        specify do
          parent.set_scrollbar(horiz: true, vert: true)
          inherited = described_class.inherit(parent)
          expect(inherited.scrollbar.horiz?).to eq(false)
          expect(inherited.scrollbar.vert?).to eq(false)
        end

        specify do
          parent.sizing = :border
          expect(described_class.inherit(parent).sizing).to eq(Sizing::DEFAULT)
        end
      end
    end
  end
end
