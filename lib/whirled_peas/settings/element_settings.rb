require 'json'

require_relative 'alignment'
require_relative 'bg_color'
require_relative 'text_color'

module WhirledPeas
  module Settings
    class ElementSettings
      def self.inherit(parent)
        child = self.new(parent.theme)
        child.inherit(parent)
        child
      end

      attr_accessor :theme, :width, :height

      def initialize(theme)
        @theme = theme
      end

      def validate!
      end

      def bg_color
        @_bg_color || theme.bg_color
      end

      def bg_color=(color)
        if color == :highlight
          @_bg_color = theme.highlight_bg_color
        else
          @_bg_color = BgColor.validate!(color)
        end
      end

      def bold?
        @_bold || false
      end

      def bold=(val)
        @_bold = val
      end

      def color
        @_color || theme.color
      end

      def color=(color)
        if color == :highlight
          @_color = theme.highlight_color
        else
          @_color = TextColor.validate!(color)
        end
      end

      def underline?
        @_underline || false
      end

      def underline=(val)
        @_underline = val
      end

      def inherit(parent)
        @_bg_color = parent._bg_color
        @_bold = parent._bold
        @_color = parent._color
        @_underline = parent._underline
      end

      protected

      attr_accessor :_bg_color, :_bold, :_color, :_underline
    end
    private_constant :ElementSettings
  end
end
