module WhirledPeas
  module Settings
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
          raise ArgumentError, "Unsupported display flow: #{flow}"
        end
      end
    end
  end
end
