module WhirledPeas
  module Settings
    class Scrollbar
      attr_writer :horiz, :vert

      def horiz?
        @horiz == true
      end

      def vert?
        @vert == true
      end
    end
  end
end
