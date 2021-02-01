module WhirledPeas
  module Device
    class RenderedFrame
      attr_reader :strokes, :duration

      def initialize(strokes, duration)
        @strokes = strokes
        @duration = duration
      end
    end
  end
end
