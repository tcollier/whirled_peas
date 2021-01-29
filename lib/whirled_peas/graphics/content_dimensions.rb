module WhirledPeas
  module Graphics
    class ContentDimensions
      attr_reader :outer_width, :outer_height

      def initialize(settings, content)
        if settings.width
          @outer_width = settings.width
        else
          @outer_width = 0
          content.each do |line|
            @outer_width = line.length if line.length > @outer_width
          end
        end
        @outer_height = settings.height || content.length
      end
    end
  end
end
