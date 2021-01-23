require 'json'

require_relative 'color'
require_relative 'text_align'

module WhirledPeas
  module Settings
    class ElementSettings
      def self.inherit(parent)
        child = self.new
        child.inherit(parent)
        child
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

      def color
        @_color
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

      attr_accessor :_bg_color, :_bold, :_color, :_underline
    end
    private_constant :ElementSettings
  end
end
