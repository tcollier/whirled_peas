module WhirledPeas
  module Command
    # Abstract base class for all commands
    class Base
      # Returns the name of the command as expected by the command line script. By convention,
      # this name is snake case version of the class name, e.g. the command `do_something`
      # would be implemented by `WhirledPeas::Command::DoSomething`, which needs to inherit
      # from this class.
      def self.command_name
        name.split('::').last.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
      end

      def self.description
      end

      def self.print_usage
        puts description
      end

      attr_reader :args

      def initialize(args, config)
        @args = args
        @config = config
      end

      # Returns the name of the command as expected by the command line script. By convention,
      # this name is snake case version of the class name, e.g. the command `do_something`
      # would be implemented by `WhirledPeas::Command::DoSomething`, which needs to inherit
      # from this class.
      def command_name
        self.class.command_name
      end

      def build_logger
        require 'logger'

        if config.log_file.is_a?(IO)
          output = config.log_file
        else
          File.open(config.log_file, 'a')
        end

        logger = Logger.new(output)
        logger.level = config.log_level
        logger.formatter = config.log_formatter
        logger
      end

      # @return [true|false] true if all of the required options were provided
      def valid?
        @error_text = nil
        validate!
        @error_text.nil?
      end

      # Display the validation error and print a usage statement
      def print_error
        puts @error_text if @error_text
        print_usage
      end

      # Commands that inherit from this class must override this method
      def start
      end

      private

      attr_reader :config

      def print_usage
        puts ["Usage: #{$0} #{command_name}", *options_usage].join(' ')
      end

      # Commands that inherit from this class can override this method to validate
      # command line options
      def validate!
        # Set @error_text if the options are not valid
      end

      def options_usage
      end
    end
    private_constant :Base
  end
end
