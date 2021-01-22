module WhirledPeas
  class Command
    def self.command_name
      self.name.split('::').last.sub(/Command$/, '').gsub(/([a-z])([A-Z])/, '\1_\2').downcase
    end

    attr_reader :args

    def initialize(args)
      @args = args
    end

    def valid?
      @help_text = nil
      validate!
      @help_text.nil?
    end

    def print_usage
      puts @help_text if @help_text
    end

    def start
    end

    private

    def validate!
      # Set @help_text if the options are not valid
    end
  end

  class ConfigCommand < Command
    def start
      require args[0]
    rescue => e
      puts "Error loading config file: #{e.class}: #{e.to_s}"
      puts e.backtrace.join("\n")
    end

    def validate!
      if args.length == 0
        @help_text = "#{self.class.command_name} requires a config file"
      elsif !File.exist?(args[0])
        @help_text = "File not found: #{args[0]}"
      elsif args[0][-3..-1] != '.rb'
        @help_text = 'Config file should be a .rb file'
      end
    end
  end

  class StartCommand < ConfigCommand
    DEFAULT_REFRESH_RATE = 30
    DEFAULT_LOG_LEVEL = Logger::INFO

    DEFAULT_FORMATTER = proc do |severity, datetime, progname, msg|
      if msg.is_a?(Exception)
        msg = %Q(#{msg.class}: #{msg.to_s}\n    #{msg.backtrace.join("\n    ")})
      end
      "[#{severity}] #{datetime.strftime('%Y-%m-%dT%H:%M:%S.%L')} (#{progname}) - #{msg}\n"
    end

    LOGGER_ID = 'MAIN'

    def start
      super
      require 'whirled_peas/frame/event_loop'
      require 'whirled_peas/frame/producer'

      logger = Logger.new(File.open('whirled_peas.log', 'a'))
      logger.level = DEFAULT_LOG_LEVEL
      logger.formatter = DEFAULT_FORMATTER
      event_loop = Frame::EventLoop.new(
        WhirledPeas.config.template_factory,
        WhirledPeas.config.loading_template_factory,
        DEFAULT_REFRESH_RATE,
        logger
      )
      Frame::Producer.produce(event_loop, logger) do |producer|
        begin
          WhirledPeas.config.driver.start(producer)
        rescue => e
          logger.warn(LOGGER_ID) { 'Driver exited with error, terminating producer...' }
          logger.error(LOGGER_ID) { e }
          raise
        end
      end
    end
  end

  class CommandLine
    COMMANDS = [StartCommand].map.with_object({}) { |c, h| h[c.command_name] = c }

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
        cmd.print_usage
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
