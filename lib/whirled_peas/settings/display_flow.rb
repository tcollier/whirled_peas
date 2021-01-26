module WhirledPeas
  module Settings
    module DisplayFlow
      LEFT_TO_RIGHT = :l2r
      RIGHT_TO_LEFT = :r2l
      TOP_TO_BOTTOM = :t2b
      BOTTOM_TO_TOP = :b2t

      DEFAULT = LEFT_TO_RIGHT

      VALID = [
        DisplayFlow::LEFT_TO_RIGHT,
        DisplayFlow::RIGHT_TO_LEFT,
        DisplayFlow::TOP_TO_BOTTOM,
        DisplayFlow::BOTTOM_TO_TOP
      ]
      private_constant :VALID

      def self.validate!(flow)
        return if flow.nil?
        return flow if VALID.include?(flow)
        raise ArgumentError, "Unsupported display flow: #{flow.inspect}"
      end
    end
    private_constant :DisplayFlow
  end
end
