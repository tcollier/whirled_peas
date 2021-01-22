require 'json'

require_relative 'color'
require_relative 'text_align'

module WhirledPeas
  module Settings
    class ElementSettings
      # Cast settings from one type to another
      def self.cast(other)
        casted = self.new
        casted.cast(other)
        casted
      end

      def self.inherit(parent)
        child = self.new
        child.inherit(parent)
        child
      end

      attr_accessor :width

      def color
        @_color
      end

      def color=(color)
        @_color = TextColor.validate!(color)
      end

      def bg_color
        @_bg_color
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

      def underline?
        @_underline || false
      end

      def underline=(val)
        @_underline = val
      end

      def align
        @_align || TextAlign::LEFT
      end

      def align=(align)
        @_align = TextAlign.validate!(align)
      end

      def cast(other)
        @_color = other._color
        @_bg_color = other._bg_color
        @_bold = other._bold
        @_underline = other._underline
        @width = other.width
        @_align = other._align
      end

      def inherit(parent)
        @_color = parent._color
        @_bg_color = parent._bg_color
        @_align = parent._align
      end

      def inspect(indent='')
        values = self.instance_variables.map do |v|
          unless instance_variable_get(v).nil? || instance_variable_get(v).inspect.nil?
            "#{indent}  #{v} = #{instance_variable_get(v).inspect}"
          end
        end.compact
        details = values.length > 0 ? values.join("\n") : "#{indent}  <default>"
        "#{indent}#{self.class.name}\n#{details}"
      end

      protected

      attr_accessor :_color, :_bg_color, :_bold, :_underline, :_align
    end
    private_constant :ElementSettings
  end
end
