require 'whirled_peas/utils/file_handler'

module WhirledPeas
  module Device
    class OutputFile
      def initialize(file)
        @file = file
      end

      def handle_rendered_frames(rendered_frames)
        Utils::FileHandler.write(file, rendered_frames)
      end

      private

      attr_reader :file
    end
  end
end
