require 'whirled_peas/settings/alignment'

module WhirledPeas
  module Settings
    RSpec.describe Alignment do
      describe '.validate!' do
        specify { expect(described_class.validate!(:left)).to eq(:left) }
        specify { expect(described_class.validate!(:center)).to eq(:center) }
        specify { expect(described_class.validate!(:right)).to eq(:right) }
        specify { expect(described_class.validate!(:between)).to eq(:between) }
        specify { expect(described_class.validate!(:around)).to eq(:around) }
        specify { expect(described_class.validate!(:evenly)).to eq(:evenly) }

        specify do
          expect do
            described_class.validate!(:garbage)
          end.to raise_error(ArgumentError, 'Unsupported alignment: :garbage')
        end
      end
    end
  end
end
