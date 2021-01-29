require 'whirled_peas/utils/file_handler'

module WhirledPeas
  module Device
    class OutputFile
      def initialize(file)
        @file = file
      end

      def handle_renders(renders)
        Utils::FileHandler.write(file, renders)
      end

      private

      attr_reader :file
    end
  end
end
