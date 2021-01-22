module WhirledPeas
  module Settings
    module TextAlign
      LEFT = :left
      CENTER = :center
      RIGHT = :right

      def self.validate!(align)
        return unless align
        if [TextAlign::LEFT, TextAlign::CENTER, TextAlign::RIGHT].include?(align)
          align
        else
          raise ArgumentError, "Unsupported text alignment: #{align}"
        end
      end
    end
  end
end
