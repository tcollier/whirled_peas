module WhirledPeas
  module Graphics
    class TextDimensions
      attr_reader :outer_width, :outer_height

      def initialize(content)
        @outer_width = 0
        content.each do |line|
          @outer_width = line.length if line.length > @outer_width
        end
        @outer_height = content.length
      end
    end
  end
end
