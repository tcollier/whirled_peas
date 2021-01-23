module WhirledPeas
  module Template
    class Element
      attr_reader :name, :settings

      def initialize(name, settings)
        @name = name
        @settings = settings
      end

      def dimensions
        raise NotImplemented, "#{self.class} must implement #dimensions"
      end
    end
    private_constant :Element
  end
end
