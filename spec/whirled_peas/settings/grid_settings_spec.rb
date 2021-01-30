require 'whirled_peas/settings/grid_settings'
require 'whirled_peas/settings/theme'

module WhirledPeas
  module Settings
    RSpec.describe GridSettings do
      it_behaves_like 'a ContainerSettings'

      context 'non-inherited attributes' do
        let(:parent) { described_class.new(theme) }

        let(:theme) { instance_double(Settings::Theme) }

        specify do
          parent.num_cols = 8
          expect(described_class.inherit(parent).num_cols).to be_nil
        end
      end
    end
  end
end
