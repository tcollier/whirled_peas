require 'whirled_peas/settings/alignment'

module WhirledPeas
  module Settings
    RSpec.describe Alignment do
      describe '.validate!' do
        specify { expect(described_class.validate!(:left)).to eq(:left) }
        specify { expect(described_class.validate!(:center)).to eq(:center) }
        specify { expect(described_class.validate!(:right)).to eq(:right) }

        specify do
          expect do
            described_class.validate!(:nonexistant)
          end.to raise_error(ArgumentError, 'Unsupported alignment: :nonexistant')
        end
      end
    end
  end
end
