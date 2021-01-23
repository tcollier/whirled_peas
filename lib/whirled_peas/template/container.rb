require_relative 'element'

module WhirledPeas
  module Template
    class Container < Element
      def initialize(name, settings)
        super
        @children = []
      end

      def add_child(child)
        @children << child
      end

      def children?
        @children.length > 0
      end

      def num_children
        @children.length
      end

      def each_child(&block)
        @children.each(&block)
      end

      def inspect(indent='')
        kids = children.map { |c| c.inspect(indent + '    ') }.join("\n")
        dims = "#{indent + '  '}- Dimensions: #{dimensions.outer_width}x#{dimensions.outer_height}"
        [
          "#{indent}+ #{name} [#{self.class.name}]",
          dims,
          "#{indent + '  '}- Settings",
          settings.inspect(indent + '    '),
          "#{indent + '  '}- Children",
          kids
        ].compact.join("\n")
      end

      private

      attr_reader :dimensions
    end
  end
end
