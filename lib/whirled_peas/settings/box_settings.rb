require_relative 'container_settings'

module WhirledPeas
  module Settings
    class BoxSettings < ContainerSettings
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

      def cast(other)
        super
        return unless other.is_a?(BoxSettings)
        @_flow = other._flow
      end

      def inherit(parent)
        super
        return unless parent.is_a?(BoxSettings)
        @_flow = parent._flow
      end

      protected

      attr_reader :_flow
    end
  end
end
