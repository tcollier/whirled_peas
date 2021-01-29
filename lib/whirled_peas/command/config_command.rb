require_relative 'base'

module WhirledPeas
  module Command
    # Abstract command that expects a config file as an argument and then requires the
    # specified file. All implementing classes must call `super` if they override `start`
    # or `validate!`
    class ConfigCommand < Base
      def start
        require config_file
      rescue => e
        puts "Error loading #{config_file}"
        puts e.message
        exit(1)
      end

      private

      attr_reader :config_file

      def validate!
        super
        # Note that the main script consumes the <command> argument from ARGV, so we
        # expect the config file to be at index 0.
        config_file = args.shift
        if config_file.nil?
          @error_text = "#{command_name} requires a config file"
        elsif !File.exist?(config_file)
          @error_text = "File not found: #{config_file}"
        elsif config_file[-3..-1] != '.rb'
          @error_text = 'Config file should be a .rb file'
        else
          # We think we have a valid ruby config file, set the absolute path to @config
          @config_file = config_file[0] == '/' ? config_file : File.join(Dir.pwd, config_file)
        end
      end

      def options_usage
        '<config file>'
      end
    end
    private_constant :ConfigCommand
  end
end
