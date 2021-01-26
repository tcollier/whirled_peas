require 'json'

require_relative 'bg_color'
require_relative 'text_align'
require_relative 'text_color'

module WhirledPeas
  module Settings
    class ElementSettings
      def self.inherit(parent)
        child = self.new
        child.inherit(parent)
        child
      end

      def bg_color
        @_bg_color || BgColor::DEFAULT
      end

      def bg_color=(color)
        @_bg_color = BgColor.validate!(color)
      end

      def bold?
        @_bold || false
      end

      def bold=(val)
        @_bold = val
      end

      def color
        @_color || TextColor::DEFAULT
      end

      def color=(color)
        @_color = TextColor.validate!(color)
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
