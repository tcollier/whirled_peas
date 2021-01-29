require_relative 'config_command'

module WhirledPeas
  module Command
    class Record < ConfigCommand
      def self.description
        'Record animation to a file'
      end

      def start
        raise NotImplementedError
      end

      private

      attr_reader :out_file

      def validate!
        super
        return unless @error_text.nil?

        out_file = args.shift
        if out_file.nil?
          @error_text = "#{command_name} requires an output file"
        elsif !out_file.end_with?('.fgz')
          @error_text = "Expecting output file with .fgz extension, found: .#{out_file.split('.').last}"
        else
          @out_file = out_file[0] == '/' ? out_file : File.join(Dir.pwd, out_file)
        end
      end

      def options_usage
        [*super, '<output file>'].join(' ')
      end
    end
  end
end
