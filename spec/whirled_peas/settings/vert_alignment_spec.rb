require 'whirled_peas/settings/vert_alignment'

module WhirledPeas
  module Settings
    RSpec.describe VertAlignment do
      describe '.validate!' do
        specify { expect(described_class.validate!(:top)).to eq(:top) }
        specify { expect(described_class.validate!(:middle)).to eq(:middle) }
        specify { expect(described_class.validate!(:bottom)).to eq(:bottom) }
        specify { expect(described_class.validate!(:between)).to eq(:between) }
        specify { expect(described_class.validate!(:around)).to eq(:around) }
        specify { expect(described_class.validate!(:evenly)).to eq(:evenly) }

        specify do
          expect do
            described_class.validate!(:garbage)
          end.to raise_error(ArgumentError, 'Unsupported vertical alignment: :garbage')
        end
      end
    end
  end
end
