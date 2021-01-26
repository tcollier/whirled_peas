module WhirledPeas
  module Settings
    class Sizing
      CONTENT = :content
      BORDER = :border

      DEFAULT = CONTENT

      VALID = [CONTENT, BORDER]
      private_constant :VALID

      def self.validate!(sizing)
        return if sizing.nil?
        return sizing if VALID.include?(sizing)
        raise ArgumentError, "Unsupported sizing model: #{sizing.inspect}"
      end
    end
  end
end
