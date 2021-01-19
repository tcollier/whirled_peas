module WhirledPeas
  module UI
    module TextAlign
      LEFT = :left
      CENTER = :center
      RIGHT = :right

      def self.validate!(align)
        return unless align
        if [TextAlign::LEFT, TextAlign::CENTER, TextAlign::RIGHT].include?(align)
          align
        else
          raise ArgumentError, "Invalid alignment: #{align}"
        end
      end
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

      def merge(parent)
        merged = Spacing.new
        merged.left = @left || parent.left
        merged.top = @top || parent.top
        merged.right = @right || parent.right
        merged.bottom = @bottom || parent.bottom
        merged
      end
    end
    private_constant :Spacing

    class Padding < Spacing
    end

    class Margin < Spacing
    end

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
        '│', '┤',
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

      def merge(parent)
        merged = Border.new
        merged.left = @left.nil? ? parent.left? : @left
        merged.top = @top.nil? ? parent.top? : @top
        merged.right = @right.nil? ? parent.right? : @right
        merged.bottom = @bottom.nil? ? parent.bottom? : @bottom
        merged.inner_horiz = @inner_horiz.nil? ? parent.inner_horiz? : @inner_horiz
        merged.inner_vert = @inner_vert.nil? ? parent.inner_vert? : @inner_vert
        merged.style = @style || parent.style
        merged.color = @color || parent.color
        puts merged.color.inspect
        merged
      end
    end

    class ElementSettings
      attr_reader :color, :bg_color
      attr_writer :bold, :underline

      def color=(color)
        @color = TextColor.validate!(color)
      end

      def bg_color=(color)
        @bg_color = BgColor.validate!(color)
      end

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
      def align
        @align || TextAlign::LEFT
      end

      def align=(align)
        @align = TextAlign.validate!(align)
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
      def set_margin(left: nil, top: nil, right: nil, bottom: nil)
        @margin = Margin.new unless @margin
        @margin.left = left if left
        @margin.top = top if top
        @margin.right = right if right
        @margin.bottom = bottom if bottom
      end

      def margin
        @margin || Margin.new
      end

      def merge(parent)
        merged = super
        merged_margin = parent.respond_to?(:margin) ? margin.merge(parent.margin) : margin
        merged.set_margin(
          left: merged_margin.left,
          top: merged_margin.top,
          right: merged_margin.right,
          bottom: merged_margin.bottom
        )
        merged
      end
    end
    private_constant :MarginSettings

    module BorderSettings
      def set_border(
        left: nil, top: nil, right: nil, bottom: nil, inner_horiz: nil, inner_vert: nil, style: nil, color: nil
      )
        @border = Border.new unless @border
        @border.left = left unless left.nil?
        @border.top = top unless top.nil?
        @border.right = right unless right.nil?
        @border.bottom = bottom unless bottom.nil?
        @border.inner_horiz = inner_horiz unless inner_horiz.nil?
        @border.inner_vert = inner_vert unless inner_vert.nil?
        @border.style = style unless style.nil?

        @border.color = TextColor.validate!(color) unless color.nil?
      end

      def no_border
        set_border(
          left: false, top: false, right: false, bottom: false, inner_horiz: false, inner_vert: false
        )
      end

      def full_border(style: nil, color: nil)
        set_border(
          left: true, top: true, right: true, bottom: true, inner_horiz: true, inner_vert: true, style: style, color: color
        )
      end

      def border
        @border || Border.new
      end

      def merge(parent)
        merged = super
        merged_border = parent.respond_to?(:border) ? border.merge(parent.border) : border
        merged.set_border(
          left: merged_border.left?,
          top: merged_border.top?,
          right: merged_border.right?,
          bottom: merged_border.bottom?,
          inner_horiz: merged_border.inner_horiz?,
          inner_vert: merged_border.inner_vert?,
          style: merged_border.style,
          color: merged_border.color
        )
        merged
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
        merged = super
        merged_padding = parent.respond_to?(:padding) ? padding.merge(parent.padding) : padding
        merged.set_padding(
          left: merged_padding.left,
          top: merged_padding.top,
          right: merged_padding.right,
          bottom: merged_padding.bottom
        )
        merged
      end
    end
    private_constant :PaddingSettings

    class TemplateSettings < ElementSettings
    end

    class TextSettings < ElementSettings
      include WidthSetting
      include AlignSetting
    end

    class ContainerSettings < ElementSettings
      include MarginSettings
      include BorderSettings
      include PaddingSettings
    end

    class BoxSettings < ContainerSettings
      include WidthSetting
      include AlignSetting
    end

    class GridSettings < ContainerSettings
      include WidthSetting
      include AlignSetting

      attr_accessor :num_cols
      attr_reader :transpose

      def transpose?
        @transpose || false
      end
    end
  end
end
