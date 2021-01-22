require 'whirled_peas/settings/box_settings'

require_relative 'container_settings_spec'

module WhirledPeas
  module Settings
    RSpec.describe BoxSettings do
      it_behaves_like 'a ContainerSettings'
    end
  end
end
