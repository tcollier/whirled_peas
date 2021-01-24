require 'json'

require 'whirled_peas/graphics/debugger'
require 'whirled_peas/graphics/renderer'
require 'whirled_peas/graphics/screen'
require 'whirled_peas/frame/debug_consumer'
require 'whirled_peas/frame/event_loop'
require 'whirled_peas/frame/producer'
require 'whirled_peas/template/debugger'

module WhirledPeas
  class Command
    DEFAULT_LOG_LEVEL = Logger::INFO
    DEFAULT_FORMATTER = proc do |severity, datetime, progname, msg|
      if msg.is_a?(Exception)
        msg = %Q(#{msg.class}: #{msg.to_s}\n    #{msg.backtrace.join("\n    ")})
      end
      "[#{severity}] #{datetime.strftime('%Y-%m-%dT%H:%M:%S.%L')} (#{progname}) - #{msg}\n"
    end

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

    def valid?
      @error_text = nil
      validate!
      @error_text.nil?
    end

    def print_error
      puts @error_text if @error_text
      print_usage
    end

    def start
    end

    private

    def print_usage
      puts "Usage: #{$0} #{self.class.command_name}"
    end

    def validate!
      # Set @error_text if the options are not valid
    end
  end

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

  class ConfigCommand < Command
    def start
      require config
    end

    private

    attr_reader :config

    def validate!
      if args.length == 0
        @error_text = "#{self.class.command_name} requires a config file"
      elsif !File.exist?(args[0])
        @error_text = "File not found: #{args[0]}"
      elsif args[0][-3..-1] != '.rb'
        @error_text = 'Config file should be a .rb file'
      else
        @config = args[0][0] == '/' ? args[0] : File.join(Dir.pwd, args[0])
      end
    end

    def print_usage
      puts "Usage: #{$0} #{self.class.command_name} <config file>"
    end
  end

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
          logger.warn(LOGGER_ID) { 'Driver exited with error, terminating producer...' }
          logger.error(LOGGER_ID) { e }
          raise
        end
      end
    end
  end

  class ListFramesCommand < ConfigCommand
    def start
      super

      Frame::Producer.produce(Frame::DebugConsumer.new) do |producer|
        WhirledPeas.config.driver.start(producer)
      end
    end
  end

  class PlayFrameCommand < ConfigCommand
    def start
      super

      if args.last == '--template'
        element = WhirledPeas.config.template_factory.build(frame, frame_args)
        puts Template::Debugger.new(element).debug
        exit
      elsif args.last == '--rendered'
        element = WhirledPeas.config.template_factory.build(frame, frame_args)
        painter = Graphics::Renderer.new(element, *Graphics::Screen.current_dimensions).painter
        puts Graphics::Debugger.new(painter).debug
        exit
      end

      logger = self.class.build_logger(File.open('whirled_peas.log', 'a'))

      consumer = Frame::EventLoop.new(
        WhirledPeas.config.template_factory,
        logger: logger
      )
      Frame::Producer.produce(consumer, logger) do |producer|
        producer.send_frame(frame, args: frame_args)
      end
    end

    private

    attr_reader :frame, :frame_args

    def validate!
      super
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
      puts "Usage: #{$0} #{self.class.command_name} <config file> <frame> [args as a JSON string] [--debug]"
    end
  end

  class LoadingCommand < ConfigCommand
    def start
      super
      unless WhirledPeas.config.loading_template_factory
        puts 'No loading screen configured'
        exit
      end

      if args.last == '--debug'
        puts WhirledPeas.config.loading_template_factory.build.inspect
        exit
      end

      logger = self.class.build_logger(File.open('whirled_peas.log', 'a'))
      consumer = Frame::EventLoop.new(
        WhirledPeas.config.template_factory,
        WhirledPeas.config.loading_template_factory,
        logger: logger
      )
      Frame::Producer.produce(consumer, logger) { sleep(5) }
    end

    private

    def print_usage
      puts "Usage: #{$0} #{self.class.command_name} [--debug]"
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
