require 'json'

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

    module DisplayFlow
      LEFT_TO_RIGHT = :l2r
      RIGHT_TO_LEFT = :r2l
      TOP_TO_BOTTOM = :t2b
      BOTTOM_TO_TOP = :b2t

      def self.validate!(flow)
        return unless flow
        if [
          DisplayFlow::LEFT_TO_RIGHT,
          DisplayFlow::RIGHT_TO_LEFT,
          DisplayFlow::TOP_TO_BOTTOM,
          DisplayFlow::BOTTOM_TO_TOP
        ].include?(flow)
          flow
        else
          raise ArgumentError, "Invalid flow: #{flow}"
        end
      end
    end

    class Spacing
      def left
        @_left || 0
      end

      def left=(val)
        @_left = val
      end

      def top
        @_top || 0
      end

      def top=(val)
        @_top = val
      end

      def right
        @_right || 0
      end

      def right=(val)
        @_right = val
      end

      def bottom
        @_bottom || 0
      end

      def bottom=(val)
        @_bottom = val
      end

      def merge(parent)
        merged = Spacing.new
        merged._left = @_left || parent._left
        merged._top = @_top || parent._top
        merged._right = @_right || parent._right
        merged._bottom = @_bottom || parent._bottom
        merged
      end

      def inspect
        vals = {}
        vals[:left] = @_left if @_left
        vals[:top] = @_top if @_top
        vals[:right] = @_right if @_right
        vals[:bottom] = @_bottom if @_bottom
        JSON.generate(vals) if vals.any?
      end

      protected

      attr_accessor :_left, :_top, :_right, :_bottom
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
      def left?
        @_left == true
      end

      def left=(val)
        @_left = val
      end

      def top?
        @_top == true
      end

      def top=(val)
        @_top = val
      end

      def right?
        @_right == true
      end

      def right=(val)
        @_right = val
      end

      def bottom?
        @_bottom == true
      end

      def bottom=(val)
        @_bottom = val
      end

      def inner_horiz?
        @_inner_horiz == true
      end

      def inner_horiz=(val)
        @_inner_horiz = val
      end

      def inner_vert?
        @_inner_vert == true
      end

      def inner_vert=(val)
        @_inner_vert = val
      end

      def style
        @_style || BorderStyles::BOLD
      end

      def style=(val)
        @_style = BorderStyles.validate!(val)
      end

      def color
        @_color || TextColor::WHITE
      end

      def color=(val)
        @_color = TextColor.validate!(val)
      end

      def merge(parent)
        merged = Border.new
        merged._left = @_left.nil? ? parent._left : @_left
        merged._top = @_top.nil? ? parent._top : @_top
        merged._right = @_right.nil? ? parent._right : @_right
        merged._bottom = @_bottom.nil? ? parent._bottom : @_bottom
        merged._inner_horiz = @_inner_horiz.nil? ? parent._inner_horiz : @_inner_horiz
        merged._inner_vert = @_inner_vert.nil? ? parent._inner_vert : @_inner_vert
        merged._style = @_style || parent._style
        merged._color = @_color || parent._color
        merged
      end

      def inspect
        vals = {}
        vals[:left] = @_left unless @_left.nil?
        vals[:top] = @_top unless @_top.nil?
        vals[:right] = @_right unless @_right.nil?
        vals[:bottom] = @_bottom unless @_bottom.nil?
        vals[:inner_horiz] = @_inner_horiz unless @_inner_horiz.nil?
        vals[:inner_vert] = @_inner_vert unless @_inner_vert.nil?
        JSON.generate(vals) if vals.any?
      end

      protected

      attr_accessor :_left, :_top, :_right, :_bottom, :_inner_horiz, :_inner_vert, :_style, :_color
    end

    class ElementSettings
      def self.merge(parent)
        self.new.merge(parent)
      end

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

      def merge(parent)
        merged = self.class.new
        merged.color = @color || parent.color
        merged.bg_color = @bg_color || parent.bg_color
        merged._bold = @_bold.nil? ? parent._bold : @_bold
        merged._underline = @_underline.nil? ? parent._underline : @_underline
        merged
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

      attr_accessor :_bold, :_underline
    end
    private_constant :ElementSettings

    module WidthSetting
      attr_accessor :width
    end

    module AlignSetting
      def align
        @_align || TextAlign::LEFT
      end

      def align=(align)
        @_align = TextAlign.validate!(align)
      end

      def merge(parent)
        merged = super
        merged._align = if @_align
          @_align
        elsif parent.is_a?(AlignSetting)
          parent._align
        end
        merged
      end

      protected

      attr_accessor :_align
    end

    module MarginSettings
      def set_margin(left: nil, top: nil, right: nil, bottom: nil)
        @_margin = Margin.new unless @_margin
        @_margin.left = left if left
        @_margin.top = top if top
        @_margin.right = right if right
        @_margin.bottom = bottom if bottom
      end

      def margin
        @_margin || Margin.new
      end

      def auto_margin=(val)
        @_auto_margin = val
      end

      def auto_margin?
        @_auto_margin || false
      end

      def merge(parent)
        merged = super
        if parent.is_a?(MarginSettings)
          merged._margin = margin.merge(parent.margin)
          merged._auto_margin = @_auto_margin.nil? ? parent._auto_margin : @_auto_margin
        else
          merged._margin = _margin
          merged._auto_margin = @_auto_margin
        end
        merged
      end

      protected

      attr_accessor :_margin, :_auto_margin
    end
    private_constant :MarginSettings

    module BorderSettings
      def set_border(
        left: nil, top: nil, right: nil, bottom: nil, inner_horiz: nil, inner_vert: nil, style: nil, color: nil
      )
        @_border = Border.new unless @_border
        @_border.left = left unless left.nil?
        @_border.top = top unless top.nil?
        @_border.right = right unless right.nil?
        @_border.bottom = bottom unless bottom.nil?
        @_border.inner_horiz = inner_horiz unless inner_horiz.nil?
        @_border.inner_vert = inner_vert unless inner_vert.nil?
        @_border.style = style unless style.nil?
        @_border.color = color unless color.nil?
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
        @_border || Border.new
      end

      def merge(parent)
        merged = super
        merged._border = parent.is_a?(BorderSettings) ? border.merge(parent.border) : _border
        merged
      end

      protected

      attr_accessor :_border
    end
    private_constant :BorderSettings

    module PaddingSettings
      def set_padding(left: nil, top: nil, right: nil, bottom: nil)
        @_padding = Padding.new unless @_padding
        @_padding.left = left if left
        @_padding.top = top if top
        @_padding.right = right if right
        @_padding.bottom = bottom if bottom
      end

      def padding
        @_padding || Padding.new
      end

      def merge(parent)
        merged = super
        merged._padding = parent.is_a?(PaddingSettings) ? padding.merge(parent.padding) : _padding
        merged
      end

      protected

      attr_accessor :_padding
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

      def flow=(flow)
        @_flow = DisplayFlow.validate!(flow)
      end

      def flow
        @_flow || DisplayFlow::LEFT_TO_RIGHT
      end

      def horizontal_flow?
        %i[l2r r2l].include?(flow)
      end

      def vertical_flow?
        !horizontal_flow?
      end

      def forward_flow?
        %i[l2r t2b].include?(flow)
      end

      def reverse_flow?
        !forward_flow?
      end

      def merge(parent)
        merged = super
        merged._flow = if @_flow
          @_flow
        elsif parent.is_a?(BoxSettings)
          parent._flow
        end
        merged
      end

      protected

      attr_accessor :_flow
    end

    class GridSettings < ContainerSettings
      include WidthSetting
      include AlignSetting

      attr_accessor :num_cols
      attr_writer :transpose

      def transpose?
        @transpose || false
      end
    end
  end
end
