module WhirledPeas
  module Settings
    module TextAlign
      LEFT = :left
      CENTER = :center
      RIGHT = :right

      DEFAULT = LEFT

      VALID = [TextAlign::LEFT, TextAlign::CENTER, TextAlign::RIGHT]
      private_constant :VALID

      def self.validate!(align)
        return if align.nil?
        return align if VALID.include?(align)
        raise ArgumentError, "Unsupported text alignment: #{align}"
      end
    end
    private_constant :TextAlign
  end
end
