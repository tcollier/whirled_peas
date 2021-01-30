require 'whirled_peas/settings/text_settings'
require 'whirled_peas/settings/theme'
require 'whirled_peas/utils/title_font'

module WhirledPeas
  module Settings
    RSpec.describe TextSettings do
      it_behaves_like 'an ElementSettings'

      describe '#title_font' do
        subject(:settings) { described_class.new(theme) }

        let(:theme) { instance_double(Settings::Theme) }

        before do
          allow(Utils::TitleFont)
            .to receive(:validate!)
            .with(:default)
            .and_return('the-font')
        end

        it 'sets the validated font' do
          settings.title_font = :default
          expect(settings.title_font).to eq('the-font')
        end
      end
    end
  end
end
