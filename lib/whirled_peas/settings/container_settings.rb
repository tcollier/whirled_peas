require_relative 'alignment'
require_relative 'border'
require_relative 'display_flow'
require_relative 'element_settings'
require_relative 'margin'
require_relative 'padding'
require_relative 'position'
require_relative 'scrollbar'
require_relative 'sizing'
require_relative 'vert_alignment'

module WhirledPeas
  module Settings
    class ContainerSettings < ElementSettings
      def align
        @_align || Alignment::DEFAULT
      end

      def align_left?
        align == Alignment::LEFT
      end

      def align_center?
        align == Alignment::CENTER
      end

      def align_right?
        align == Alignment::RIGHT
      end

      def align_between?
        align == Alignment::BETWEEN
      end

      def align_around?
        align == Alignment::AROUND
      end

      def align_evenly?
        align == Alignment::EVENLY
      end

      def align=(align)
        @_align = Alignment.validate!(align)
      end

      def valign
        @_valign || VertAlignment::DEFAULT
      end

      def valign_top?
        valign == VertAlignment::TOP
      end

      def valign_middle?
        valign == VertAlignment::MIDDLE
      end

      def valign_bottom?
        valign == VertAlignment::BOTTOM
      end

      def valign_between?
        valign == VertAlignment::BETWEEN
      end

      def valign_around?
        valign == VertAlignment::AROUND
      end

      def valign_evenly?
        valign == VertAlignment::EVENLY
      end

      def valign=(valign)
        @_valign = VertAlignment.validate!(valign)
      end

      def set_border(
        left: nil, top: nil, right: nil, bottom: nil, inner_horiz: nil, inner_vert: nil, style: nil, color: nil
      )
        border.left = left unless left.nil?
        border.top = top unless top.nil?
        border.right = right unless right.nil?
        border.bottom = bottom unless bottom.nil?
        border.inner_horiz = inner_horiz unless inner_horiz.nil?
        border.inner_vert = inner_vert unless inner_vert.nil?
        border.style = style unless style.nil?
        border.color = color unless color.nil?
      end

      def full_border(style: nil, color: nil)
        set_border(
          left: true, top: true, right: true, bottom: true, inner_horiz: true, inner_vert: true, style: style, color: color
        )
      end

      def border
        @_border ||= Border.new(theme)
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

      def set_margin(left: nil, top: nil, right: nil, bottom: nil, horiz: nil, vert: nil)
        if horiz && (left || right)
          raise ArgumentError, 'Cannot set horizontal margin when setting left/right'
        elsif vert && (top || bottom)
          raise ArgumentError, 'Cannot set vertical margin when setting top/bottom'
        end

        if horiz
          margin.horiz = horiz
        else
          margin.left = left if left
          margin.right = right if right
        end

        if vert
          margin.vert = vert
        else
          margin.top = top if top
          margin.bottom = bottom if bottom
        end
      end

      def margin
        @_margin ||= Margin.new
      end

      def set_padding(left: nil, top: nil, right: nil, bottom: nil, horiz: nil, vert: nil)
        if horiz && (left || right)
          raise ArgumentError, 'Cannot set horizontal padding when setting left/right'
        elsif vert && (top || bottom)
          raise ArgumentError, 'Cannot set vertical padding when setting top/bottom'
        end

        if horiz
          padding.horiz = horiz
        else
          padding.left = left if left
          padding.right = right if right
        end

        if vert
          padding.vert = vert
        else
          padding.top = top if top
          padding.bottom = bottom if bottom
        end
      end

      def padding
        @_padding ||= Padding.new
      end

      def set_position(left: nil, top: nil)
        position.left = left if left
        position.top = top if top
      end

      def position
        @_position ||= Position.new
      end

      def set_scrollbar(horiz: nil, vert: nil)
        scrollbar.horiz = horiz unless horiz.nil?
        scrollbar.vert = vert unless vert.nil?
      end

      def scrollbar
        @_scrollbar ||= Scrollbar.new
      end

      def sizing
        @_sizing || Sizing::DEFAULT
      end

      def border_sizing?
        @_sizing == Sizing::BORDER
      end

      def content_sizing?
        @_sizing == Sizing::CONTENT
      end

      def sizing=(sizing)
        @_sizing = Sizing.validate!(sizing)
      end

      def inherit(parent)
        super
        return unless parent.is_a?(ContainerSettings)
        @_border = Border.inherit(parent.border)
      end

      protected
    end
  end
end
