require 'whirled_peas/command/debug'
require 'whirled_peas/command/fonts'
require 'whirled_peas/command/frames'
require 'whirled_peas/command/help'
require 'whirled_peas/command/play'
require 'whirled_peas/command/record'
require 'whirled_peas/command/still'

module WhirledPeas
  class CommandLine
    COMMANDS = [
      Command::Debug,
      Command::Fonts,
      Command::Frames,
      Command::Help,
      Command::Play,
      Command::Record,
      Command::Still
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

      cmd = COMMANDS[command].new(args, WhirledPeas.config)

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
      puts 'Available commands:'
      puts
      max_name_length = 0
      COMMANDS.keys.each { |c| max_name_length = c.length if c.length > max_name_length }
      COMMANDS.each do |name, klass|
        puts "    #{name.ljust(max_name_length, ' ')}    #{klass.description}"
      end
    end
  end
end
