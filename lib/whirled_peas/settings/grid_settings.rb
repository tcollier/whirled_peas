require 'whirled_peas/utils/title_font'

require_relative 'container_settings'

module WhirledPeas
  module Settings
    class GridSettings < ContainerSettings
      attr_accessor :num_cols
    end
  end
end
