require_relative 'text_color'
require_relative 'element_settings'

module WhirledPeas
  module Settings
    class GraphSettings < ElementSettings
      def axis_color
        @_axis_color || theme.axis_color
      end

      def axis_color=(color)
        @_axis_color = TextColor.validate!(color)
      end

      def validate!
        super
        raise SettingsError, "`height` must be set for GraphSettings" if height.nil?
      end
    end
  end
end
