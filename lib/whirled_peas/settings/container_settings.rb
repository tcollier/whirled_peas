require_relative 'border'
require_relative 'display_flow'
require_relative 'element_settings'
require_relative 'margin'
require_relative 'padding'
require_relative 'position'
require_relative 'scrollbar'

module WhirledPeas
  module Settings
    class ContainerSettings < ElementSettings
      attr_accessor :width, :height

      def align
        @_align || TextAlign::DEFAULT
      end

      def align_left?
        align == TextAlign::LEFT
      end

      def align_center?
        align == TextAlign::CENTER
      end

      def align_right?
        align == TextAlign::RIGHT
      end

      def align=(align)
        @_align = TextAlign.validate!(align)
      end

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

      def full_border(style: nil, color: nil)
        set_border(
          left: true, top: true, right: true, bottom: true, inner_horiz: true, inner_vert: true, style: style, color: color
        )
      end

      def border
        @_border || Border.new
      end

      def flow=(flow)
        @_flow = DisplayFlow.validate!(flow)
      end

      def flow
        @_flow || DisplayFlow::DEFAULT
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

      def set_position(left: nil, top: nil)
        @_position = Position.new unless @_position
        @_position.left = left if left
        @_position.top = top if top
      end

      def position
        @_position || Position.new
      end

      def set_scrollbar(horiz: nil, vert: nil)
        @_scrollbar = Scrollbar.new unless @_scrollbar
        @_scrollbar.horiz = horiz unless horiz.nil?
        @_scrollbar.vert = vert unless vert.nil?
      end

      def scrollbar
        @_scrollbar || Scrollbar.new
      end

      def inherit(parent)
        super
        return unless parent.is_a?(ContainerSettings)
        set_border(color: parent.border.color, style: parent.border.style)
      end

      protected
    end
  end
end
