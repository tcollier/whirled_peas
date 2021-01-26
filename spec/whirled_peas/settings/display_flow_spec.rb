require 'whirled_peas/settings/display_flow'

module WhirledPeas
  module Settings
    RSpec.describe DisplayFlow do
      describe '.validate!' do
        specify { expect(described_class.validate!(:l2r)).to eq(:l2r) }
        specify { expect(described_class.validate!(:t2b)).to eq(:t2b) }
        specify { expect(described_class.validate!(:r2l)).to eq(:r2l) }
        specify { expect(described_class.validate!(:b2t)).to eq(:b2t) }

        specify do
          expect do
            described_class.validate!(:garbage)
          end.to raise_error(ArgumentError, 'Unsupported display flow: :garbage')
        end
      end
    end
  end
end
