require 'whirled_peas/settings/template_settings'

require_relative 'element_settings_spec'

module WhirledPeas
  module Settings
    RSpec.describe TemplateSettings do
      it_behaves_like 'an ElementSettings'
    end
  end
end
