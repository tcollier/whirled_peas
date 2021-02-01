require 'base64'
require 'zlib'

require 'whirled_peas/device/rendered_frame'

module WhirledPeas
  module Utils
    module FileHandler
      module FileWriter
        VERSION = '1'

        def self.write(fp, rendered_frames)
          fp.puts rendered_frames.count
          rendered_frames.each do |rendered_frame|
            fp.puts rendered_frame.duration
            encoded = Base64.encode64(rendered_frame.strokes)
            fp.puts encoded.count("\n")
            fp.puts encoded
          end
        end
      end
      private_constant :FileWriter

      class FileReaderV1
        def self.read(fp)
          num_frames = Integer(fp.readline.chomp, 10)
          num_frames.times.map do
            duration = Float(fp.readline.chomp)
            num_strokes = Integer(fp.readline.chomp, 10)
            strokes = Base64.decode64(num_strokes.times.map { fp.readline }.join)
            Device::RenderedFrame.new(strokes, duration)
          end
        end

        private

        attr_reader :file
      end
      private_constant :FileReaderV1

      READERS = {
        '1' => FileReaderV1
      }
      private_constant :READERS

      def self.write(file, rendered_frames)
        Zlib::GzipWriter.open(file, Zlib::BEST_COMPRESSION) do |gz|
          gz.puts FileWriter::VERSION
          FileWriter.write(gz, rendered_frames)
        end
      end

      def self.read(file)
        Zlib::GzipReader.open(file) do |gz|
          version = gz.gets.chomp
          raise ArgumentError, "Invalid file: #{file}" unless READERS.key?(version)
          READERS[version].read(gz)
        end
      end
    end
  end
end
