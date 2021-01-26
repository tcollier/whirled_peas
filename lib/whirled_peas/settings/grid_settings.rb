require 'whirled_peas/utils/title_font'

require_relative 'container_settings'

module WhirledPeas
  module Settings
    class GridSettings < ContainerSettings
      attr_accessor :num_cols

      def set_scrollbar(*)
        raise NotImplemented, 'Grids do not currently support scrollbars'
      end
    end
  end
end
