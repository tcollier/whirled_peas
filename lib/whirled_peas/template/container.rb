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
    end
  end
end
