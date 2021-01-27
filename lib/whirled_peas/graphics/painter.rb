module WhirledPeas
  module Graphics
    class Painter
      attr_reader :name, :settings

      def initialize(name, settings)
        @settings = settings
        @name = name
      end

      def paint(canvas, &block)
      end

      def dimensions
      end

      def inspect
        "#{self.class.name.split('::').last}(name=#{name.inspect})"
      end
    end
    private_constant :Painter
  end
end
