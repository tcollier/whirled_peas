module WhirledPeas
  module Graphics
    class TextDimensions
      attr_reader :outer_width, :outer_height

      def initialize(settings, content)
        @outer_width = settings.width
        @outer_height = settings.height
      end
    end
  end
end
