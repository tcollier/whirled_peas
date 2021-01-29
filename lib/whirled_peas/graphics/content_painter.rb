require_relative 'painter'

module WhirledPeas
  module Graphics
    class ContentPainter < Painter
      attr_accessor :content

      def dimensions
        ContentDimensions.new(settings, content_lines)
      end

      private

      def content_lines
        raise NotImplementedError, "#{self.class} must implement #content_lines"
      end
    end
    private_constant :ContentPainter
  end
end
