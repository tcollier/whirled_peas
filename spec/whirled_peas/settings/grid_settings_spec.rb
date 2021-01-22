require 'whirled_peas/settings/grid_settings'

require_relative 'container_settings_spec'

module WhirledPeas
  module Settings
    RSpec.describe GridSettings do
      it_behaves_like 'a ContainerSettings'
    end
  end
end
