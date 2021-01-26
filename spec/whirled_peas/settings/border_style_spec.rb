require 'whirled_peas/settings/border'

module WhirledPeas
  module Settings
    RSpec.describe Border::Styles do
      describe '.validate!' do
        specify { expect(described_class.validate!(:bold)).to eq(Border::Styles::BOLD) }
        specify { expect(described_class.validate!(:soft)).to eq(Border::Styles::SOFT) }
        specify { expect(described_class.validate!(:double)).to eq(Border::Styles::DOUBLE) }

        specify do
          expect do
            described_class.validate!(:nonexistant)
          end.to raise_error(ArgumentError, 'Unsupported border style: :nonexistant')
        end
      end
    end
  end
end
