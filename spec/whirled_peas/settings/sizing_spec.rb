require 'whirled_peas/settings/sizing'

module WhirledPeas
  module Settings
    RSpec.describe Sizing do
      describe '.validate!' do
        specify { expect(described_class.validate!(:border)).to eq(:border) }
        specify { expect(described_class.validate!(:content)).to eq(:content) }

        specify do
          expect do
            described_class.validate!(:garbage)
          end.to raise_error(ArgumentError, 'Unsupported sizing model: :garbage')
        end
      end
    end
  end
end
