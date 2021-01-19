module WhirledPeas
  module UI
    module TextAlign
      LEFT = 1
      CENTER = 2
      RIGHT = 3
    end

    class Spacing
      attr_writer :left, :top, :right, :bottom

      def left
        @left || 0
      end

      def top
        @top || 0
      end

      def right
        @right || 0
      end

      def bottom
        @bottom || 0
      end
    end
    private_constant :Spacing

    class Padding < Spacing
    end

    class Margin < Spacing
      def auto?
        false
      end
    end

    class AutoMargin
      def initialize(top: nil, bottom: nil)
        @top = top
        @bottom = bottom
      end

      def auto?
        true
      end

      def top
        @top || 0
      end

      def bottom
        @bottom || 0
      end

      def left
        0
      end

      def right
        0
      end
    end


    BorderStyle = Struct.new(
      :top_left, :top_horiz, :top_junc, :top_right,
      :left_vert, :left_junc,
      :cross,
      :right_vert, :right_junc,
      :bottom_left, :bottom_horiz, :bottom_junc, :bottom_right
    )

    module BorderStyles
      BOLD = BorderStyle.new(
        '┏', '━', '┳', '┓',
        '┃', '┣',
        '╋',
        '┃', '┫',
        '┗', '━', '┻', '┛'
      )
      SOFT = BorderStyle.new(
        '╭', '─', '┬', '╮',
        '│', '┤',
        '┼',
        '│', '┤',
        '╰', '─', '┴', '╯'
      )
      DOUBLE = BorderStyle.new(
        '╔', '═', '╦', '╗',
        '║', '╠',
        '╬',
        '║', '╣',
        '╚', '═', '╩', '╝'
      )
    end

    class Border
      attr_accessor :color, :style

      attr_writer :left, :top, :right, :bottom, :inner_horiz, :inner_vert

      def style
        @style || BorderStyles::BOLD
      end

      def color
        @color || TextColor::WHITE
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
    end

    class ElementSettings
      attr_accessor :color, :bg_color
      attr_writer :bold, :underline

      def bold?
        @bold || false
      end

      def underline?
        @underline || false
      end

      def merge(parent)
        merged = self.class.new
        merged.color = @color || parent.color
        merged.bg_color = @bg_color || parent.bg_color
        merged.bold = @bold.nil? ? parent.bold? : @bold
        merged.underline = @underline.nil? ? parent.underline? : @underline
        merged
      end
    end
    private_constant :ElementSettings

    module WidthSetting
      attr_accessor :width

      def merge(parent)
        merged = super
        merged.width = if @width
          @width
        elsif parent.respond_to?(:width)
          parent.width
        end
        merged
      end
    end

    module AlignSetting
      attr_writer :align

      def align
        @align || TextAlign::LEFT
      end

      def merge(parent)
        merged = super
        merged.align = if @align
          @align
        elsif parent.respond_to?(:align)
          parent.align
        end
        merged
      end
    end

    module MarginSettings
      def set_auto_margin(top: nil, bottom: nil)
        @margin = AutoMargin.new unless @margin && @margin.auto?
        @margin.top = top if top
        @margin.bottom = bottom if bottom
      end

      def set_margin(left: nil, top: nil, right: nil, bottom: nil)
        @margin = Margin.new unless @margin && !@margin.auto?
        @margin.left = left if left
        @margin.top = top if top
        @margin.right = right if right
        @margin.bottom = bottom if bottom
      end

      def margin
        @margin || Margin.new
      end

      def merge(parent)
        super
      end
    end
    private_constant :MarginSettings

    module BorderSettings
      def set_border(left: nil, top: nil, right: nil, bottom: nil, style: nil, color: nil)
        @border = Border.new unless @border
        @border.left = left unless left.nil?
        @border.top = top unless top.nil?
        @border.right = right unless right.nil?
        @border.bottom = bottom unless bottom.nil?
        @border.style = style unless style.nil?
        @border.color = color unless color.nil?
      end

      def border
        @border || Border.new
      end

      def merge(parent)
        super
      end
    end
    private_constant :BorderSettings

    module PaddingSettings
      def set_padding(left: nil, top: nil, right: nil, bottom: nil)
        @padding = Padding.new unless @padding
        @padding.left = left if left
        @padding.top = top if top
        @padding.right = right if right
        @padding.bottom = bottom if bottom
      end

      def padding
        @padding || Padding.new
      end

      def merge(parent)
        super
      end
    end
    private_constant :PaddingSettings

    class TemplateSettings < ElementSettings
    end

    class TextSettings < ElementSettings
      include WidthSetting
      include AlignSetting
    end

    class BoxSettings < ElementSettings
      include WidthSetting
      include AlignSetting
      include MarginSettings
      include BorderSettings
      include PaddingSettings
    end

    class GridSettings < ElementSettings
      include WidthSetting
      include AlignSetting
      include MarginSettings
      include BorderSettings
      include PaddingSettings

      attr_accessor :num_cols
      attr_reader :transpose

      def transpose?
        @transpose || false
      end
    end
  end
end
