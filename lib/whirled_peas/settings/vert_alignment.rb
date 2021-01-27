module WhirledPeas
  module Settings
    module VertAlignment
      TOP = :top
      MIDDLE = :middle
      BOTTOM = :bottom
      BETWEEN = :between
      AROUND = :around
      EVENLY = :evenly

      DEFAULT = TOP

      VALID = [TOP, MIDDLE, BOTTOM, BETWEEN, AROUND, EVENLY]
      private_constant :VALID

      def self.validate!(valign)
        return if valign.nil?
        return valign if VALID.include?(valign)
        raise ArgumentError, "Unsupported vertical alignment: #{valign.inspect}"
      end
    end
    private_constant :VertAlignment
  end
end
