require 'whirled_peas/settings/text_align'

module WhirledPeas
  module Settings
    RSpec.describe TextAlign do
      describe '.validate!' do
        specify { expect(described_class.validate!(:left)).to eq(:left) }
        specify { expect(described_class.validate!(:center)).to eq(:center) }
        specify { expect(described_class.validate!(:right)).to eq(:right) }

        specify do
          expect do
            described_class.validate!(:nonexistant)
          end.to raise_error(ArgumentError, 'Unsupported text alignment: nonexistant')
        end
      end
    end
  end
end
