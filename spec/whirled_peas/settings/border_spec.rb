require 'whirled_peas/settings/border'
require 'whirled_peas/settings/theme'

module WhirledPeas
  module Settings
    RSpec.describe Border do
      context 'validated attributes' do
        subject(:settings) { described_class.new(theme) }

        let(:theme) { instance_double(Theme) }

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
