require_relative 'text_color'

module WhirledPeas
  module Settings
    class Border
      Style = Struct.new(
        :top_left, :top_horiz, :top_junc, :top_right,
        :left_vert, :left_junc,
        :middle_vert, :cross_junc, :middle_horiz,
        :right_vert, :right_junc,
        :bottom_left, :bottom_horiz, :bottom_junc, :bottom_right
      )

      module Styles
        BOLD = Style.new(
          '┏', '━', '┳', '┓',
          '┃', '┣',
          '┃', '╋', '━',
          '┃', '┫',
          '┗', '━', '┻', '┛'
        )
        SOFT = Style.new(
          '╭', '─', '┬', '╮',
          '│', '├',
          '│', '┼', '─',
          '│', '┤',
          '╰', '─', '┴', '╯'
        )
        DOUBLE = Style.new(
          '╔', '═', '╦', '╗',
          '║', '╠',
          '║', '╬', '═',
          '║', '╣',
          '╚', '═', '╩', '╝'
        )

        DEFAULT = SOFT

        def self.validate!(style)
          return if style.nil?
          return style if style.is_a?(Border::Style)
          if style.is_a?(Symbol)
            style_class = self.const_get(style.upcase)
            return style_class if style_class.is_a?(Border::Style)
          end
          error_message = "Unsupported border style: #{style.inspect}"
          raise ArgumentError, error_message
        rescue NameError
          error_message = "Unsupported border style: #{style.inspect}"
          raise ArgumentError, error_message
        end
      end

      def self.inherit(parent)
        border = new(parent.theme)
        border.inherit(parent)
        border
      end

      attr_reader :theme

      attr_writer :left, :top, :right, :bottom, :inner_horiz, :inner_vert

      def initialize(theme)
        @theme = theme
      end

      def left?
        @left == true
      end

      def top?
        @top == true
      end

      def right?
        @right == true
      end

      def bottom?
        @bottom == true
      end

      def inner_horiz?
        @inner_horiz == true
      end

      def inner_vert?
        @inner_vert == true
      end

      def outer?
        left? || top? || right? || bottom?
      end

      def style
        @_style || theme.border_style || Styles::DEFAULT
      end

      def style=(val)
        @_style = Styles.validate!(val)
      end

      def color=(val)
        @_color = TextColor.validate!(val)
      end

      def color
        @_color || theme.border_color
      end

      def inherit(parent)
        @_style = parent._style
        @_color = parent._color
      end

      protected

      attr_reader :_style, :_color
    end
  end
end
