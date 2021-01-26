require 'whirled_peas/settings/border'

module WhirledPeas
  module Settings
    RSpec.describe Border do
      context 'validated attributes' do
        subject(:settings) { described_class.new }

        specify do
          expect { subject.color = :garbage }.to raise_error(ArgumentError, 'Unsupported TextColor: :garbage')
        end

        specify do
          expect { subject.style = :garbage }.to raise_error(ArgumentError, 'Unsupported border style: :garbage')
        end
      end
    end
  end
end
