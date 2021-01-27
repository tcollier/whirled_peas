require 'whirled_peas/utils/title_font'

require_relative 'container_settings'

module WhirledPeas
  module Settings
    class GridSettings < ContainerSettings
      attr_accessor :num_cols

      def set_scrollbar(*)
        raise NotImplementedError, 'Grids do not support scrollbars'
      end

      def sizing=(*)
        raise NotImplementedError, 'Grids only support the default sizing model'
      end
    end
  end
end
