require 'json'

require_relative 'color'

module WhirledPeas
  module Settings
    BorderStyle = Struct.new(
      :top_left, :top_horiz, :top_junc, :top_right,
      :left_vert, :left_junc,
      :middle_vert, :cross_junc, :middle_horiz,
      :right_vert, :right_junc,
      :bottom_left, :bottom_horiz, :bottom_junc, :bottom_right
    )

    module BorderStyles
      BOLD = BorderStyle.new(
        '┏', '━', '┳', '┓',
        '┃', '┣',
        '┃', '╋', '━',
        '┃', '┫',
        '┗', '━', '┻', '┛'
      )
      SOFT = BorderStyle.new(
        '╭', '─', '┬', '╮',
        '│', '├',
        '│', '┼', '─',
        '│', '┤',
        '╰', '─', '┴', '╯'
      )
      DOUBLE = BorderStyle.new(
        '╔', '═', '╦', '╗',
        '║', '╠',
        '║', '╬', '═',
        '║', '╣',
        '╚', '═', '╩', '╝'
      )

      def self.validate!(style)
        return unless style
        if style.is_a?(Symbol)
          error_message = "Unsupported border style: #{style}"
          begin
            style = self.const_get(style.upcase)
            raise ArgumentError, error_message unless style.is_a?(BorderStyle)
            style
          rescue NameError
            raise ArgumentError, error_message
          end
        else
          style
        end
      end
    end

    class Border
      attr_writer :left, :top, :right, :bottom, :inner_horiz, :inner_vert

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

      def style
        @style || BorderStyles::BOLD
      end

      def style=(val)
        @style = BorderStyles.validate!(val)
      end

      def color
        @color || TextColor::WHITE
      end

      def color=(val)
        @color = TextColor.validate!(val)
      end

      def inspect
        vals = {}
        vals[:left] = @left unless @left.nil?
        vals[:top] = @top unless @top.nil?
        vals[:right] = @right unless @right.nil?
        vals[:bottom] = @bottom unless @bottom.nil?
        vals[:inner_horiz] = @inner_horiz unless @inner_horiz.nil?
        vals[:inner_vert] = @inner_vert unless @inner_vert.nil?
        JSON.generate(vals) if vals.any?
      end
    end
  end
end
