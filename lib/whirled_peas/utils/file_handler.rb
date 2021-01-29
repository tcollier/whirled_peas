require 'base64'
require 'zlib'

module WhirledPeas
  module Utils
    module FileHandler
      module FileWriter
        VERSION = '1'

        def self.write(fp, renders)
          fp.puts renders.count
          renders.each do |strokes|
            encoded = Base64.encode64(strokes)
            fp.puts encoded.count("\n")
            fp.puts encoded
          end
        end
      end
      private_constant :FileWriter

      class FileReaderV1
        def self.read(fp)
          num_renders = Integer(fp.readline.chomp, 10)
          num_renders.times.map do
            num_strokes = Integer(fp.readline.chomp, 10)
            Base64.decode64(num_strokes.times.map { fp.readline }.join)
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

      def self.write(file, renders)
        Zlib::GzipWriter.open(file, Zlib::BEST_COMPRESSION) do |gz|
          gz.puts FileWriter::VERSION
          FileWriter.write(gz, renders)
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
