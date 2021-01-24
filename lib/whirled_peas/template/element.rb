module WhirledPeas
  module Template
    class Element
      attr_reader :name, :settings

      def initialize(name, settings)
        @name = name
        @settings = settings
      end
    end
    private_constant :Element
  end
end
