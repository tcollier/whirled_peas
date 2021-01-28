require 'json'
require 'logger'

require 'whirled_peas/graphics/debugger'
require 'whirled_peas/graphics/renderer'
require 'whirled_peas/graphics/screen'
require 'whirled_peas/frame/debug_consumer'
require 'whirled_peas/frame/event_loop'
require 'whirled_peas/frame/producer'

module WhirledPeas
  # Support code for the command line script (`whirled_peas`) distributed with the gem.
  class Command
    DEFAULT_LOG_LEVEL = Logger::INFO

    # This formatter expects a loggers to send `progname` in each log call. This value
    # should be an all uppercase version of the module or class that is invoking the
    # logger. Ruby's logger supports setting this value on a per-log statement basis
    # when the log message is passed in through a block:
    #
    #   logger.<level>(progname, &block)
    #
    # E.g.
    #
    #   class Foo
    #     def bar
    #       logger.warn('FOO') { 'Something fishy happened in #bar' }
    #     end
    #   end
    #
    # The block format also has the advantage that the evaluation of the block only
    # occurs if the message gets logged. So expensive to calculate debug statements
    # will not impact the performance of the application if the log level is INFO or
    # higher.
    DEFAULT_FORMATTER = proc do |severity, datetime, progname, msg|
      if msg.is_a?(Exception)
        msg = %Q(#{msg.class}: #{msg.to_s}\n    #{msg.backtrace.join("\n    ")})
      end
      "[#{severity}] #{datetime.strftime('%Y-%m-%dT%H:%M:%S.%L')} (#{progname}) - #{msg}\n"
    end

    # Returns the name of the command as expected by the command line script. By convention,
    # this name is snake case and the class name is camel case with the word `Command` appened,
    # e.g. the command `do_something` would be implemented by `WhirledPeas::DoSomethingCommand`,
    # which needs to inherit from this class.
    def self.command_name
      self.name.split('::').last.sub(/Command$/, '').gsub(/([a-z])([A-Z])/, '\1_\2').downcase
    end

    def self.build_logger(output, level=DEFAULT_LOG_LEVEL, formatter=DEFAULT_FORMATTER)
      logger = Logger.new(output)
      logger.level = level
      logger.formatter = formatter
      logger
    end

    attr_reader :args

    def initialize(args)
      @args = args
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

    def print_usage
      puts "Usage: #{$0} #{self.class.command_name}"
    end

    # Commands that inherit from this class can override this method to validate
    # command line options
    def validate!
      # Set @error_text if the options are not valid
    end
  end

  # List title fonts installed on the user's system and print sample text in each.
  class TitleFontsCommand < Command
    def start
      require 'whirled_peas/utils/title_font'

      Utils::TitleFont.fonts.keys.each do |key|
        puts Utils::TitleFont.to_s(key.to_s, key)
        puts key.inspect
        puts
      end
    end
  end

  # Abstract command that expects a config file as an argument and then requires the
  # specified file. All implementing classes must call `super` if they override `start`
  # or `validate!`
  class ConfigCommand < Command
    def start
      require config
    end

    private

    attr_reader :config

    def validate!
      # Note that the main script consumes the <command> argument from ARGV, so we
      # expect the config file to be at index 0.
      config_file = args.first
      if config_file.nil?
        @error_text = "#{self.class.command_name} requires a config file"
      elsif !File.exist?(config_file)
        @error_text = "File not found: #{config_file}"
      elsif config_file[-3..-1] != '.rb'
        @error_text = 'Config file should be a .rb file'
      else
        # We think we have a valid ruby config file, set the absolute path to @config
        @config = config_file[0] == '/' ? config_file : File.join(Dir.pwd, config_file)
      end
    end

    def print_usage
      puts "Usage: #{$0} #{self.class.command_name} <config file>"
    end
  end

  # Start the animation
  class StartCommand < ConfigCommand
    LOGGER_ID = 'MAIN'

    def start
      super

      logger = self.class.build_logger(File.open('whirled_peas.log', 'a'))

      consumer = Frame::EventLoop.new(
        WhirledPeas.config.template_factory,
        WhirledPeas.config.loading_template_factory,
        logger: logger
      )
      Frame::Producer.produce(consumer, logger) do |producer|
        begin
          WhirledPeas.config.driver.start(producer)
        rescue => e
          logger.warn(LOGGER_ID) { 'Driver exited with error...' }
          logger.error(LOGGER_ID) { e }
          raise
        end
      end
    end
  end

  # Run the driver, but print out the name, duration, and arguments of each frame.
  # This can a useful way to debug the driver or to get the name and arguments of a
  # frame to feed to the `play_frame` command
  class ListFramesCommand < ConfigCommand
    def start
      super

      Frame::Producer.produce(Frame::DebugConsumer.new) do |producer|
        WhirledPeas.config.driver.start(producer)
      end
    end
  end

  # Display the single rendered frame with the specified arguments. If the `--template`
  # argument is provided, print out the template tree instead of the rendered frame.
  class PlayFrameCommand < ConfigCommand
    def start
      super

      if args.last == '--template'
        template = WhirledPeas.config.template_factory.build(frame, frame_args)
        puts Graphics::Debugger.new(template).debug
      else
        logger = self.class.build_logger(File.open('whirled_peas.log', 'a'))
        consumer = Frame::EventLoop.new(
          WhirledPeas.config.template_factory,
          logger: logger
        )
        Frame::Producer.produce(consumer, logger) do |producer|
          producer.send_frame(frame, args: frame_args)
        end
      end
    end

    private

    attr_reader :frame, :frame_args

    def validate!
      super
      # Recall that the main script consumed the first argument from ARGV
      if !@error_text.nil?
        return
      elsif args.length < 2
        @error_text = "#{self.class.command_name} requires a frame name"
      else
        @frame = args[1]
        @frame_args = {}
        return if args.length < 3 || args[2][0..1] == '--'
        JSON.parse(args[2] || '{}').each do |key, value|
          @frame_args[key.to_sym] = value
        end
      end
    end

    def print_usage
      puts "Usage: #{$0} #{self.class.command_name} <config file> <frame> [args as a JSON string] [--template]"
    end
  end

  # Display the single rendered frame from the loading template. If the `--template`
  # argument is provided, print out the template tree instead of the rendered frame.
  class LoadingCommand < ConfigCommand
    def start
      super
      unless WhirledPeas.config.loading_template_factory
        puts 'No loading screen configured'
        exit(1)
      end

      if args.last == '--template'
        template = WhirledPeas.config.loading_template_factory.build
        puts Graphics::Debugger.new(template).debug
      else
        logger = self.class.build_logger(File.open('whirled_peas.log', 'a'))
        consumer = Frame::EventLoop.new(
          WhirledPeas.config.template_factory,
          WhirledPeas.config.loading_template_factory,
          logger: logger
        )
        Frame::Producer.produce(consumer, logger) { sleep(5) }
      end
    end

    private

    def print_usage
      puts "Usage: #{$0} #{self.class.command_name} [--template]"
    end
  end

  class CommandLine
    COMMANDS = [
      StartCommand,
      ListFramesCommand,
      PlayFrameCommand,
      LoadingCommand,
      TitleFontsCommand
    ].map.with_object({}) { |c, h| h[c.command_name] = c }

    def initialize(args)
      @args = args
    end

    def start
      if args.length < 1
        print_usage
        exit(1)
      end

      command = args.shift

      unless COMMANDS.key?(command)
        puts "Unrecognized command: #{command}"
        print_usage
        exit(1)
      end

      cmd = COMMANDS[command].new(args)

      unless cmd.valid?
        cmd.print_error
        exit(1)
      end

      cmd.start
    end

    private

    attr_reader :args

    def print_usage
      puts "Usage: #{$0} <command> [command options]"
      puts
      puts "Available commands: #{COMMANDS.keys.join(', ')}"
    end
  end
end
