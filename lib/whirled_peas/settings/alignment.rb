module WhirledPeas
  module Settings
    module Alignment
      LEFT = :left
      CENTER = :center
      RIGHT = :right

      DEFAULT = LEFT

      VALID = [LEFT, CENTER, RIGHT]
      private_constant :VALID

      def self.validate!(align)
        return if align.nil?
        return align if VALID.include?(align)
        raise ArgumentError, "Unsupported alignment: #{align.inspect}"
      end
    end
    private_constant :Alignment
  end
end
