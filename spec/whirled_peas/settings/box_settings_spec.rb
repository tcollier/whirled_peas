require 'whirled_peas/settings/box_settings'

module WhirledPeas
  module Settings
    RSpec.describe BoxSettings do
      it_behaves_like 'a ContainerSettings'

      context 'inherited attributes' do
        let(:parent) { described_class.new }

        specify do
          parent.flow = DisplayFlow::BOTTOM_TO_TOP
          expect(described_class.inherit(parent).flow).to eq(DisplayFlow::BOTTOM_TO_TOP)
        end
      end
    end
  end
end
