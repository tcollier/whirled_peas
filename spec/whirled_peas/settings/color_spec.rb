require 'whirled_peas/settings/color'

module WhirledPeas
  module Settings
    RSpec.describe TextColor do
      it_behaves_like 'a Color'
    end

    RSpec.describe BgColor do
      it_behaves_like 'a Color'
    end
  end
end
