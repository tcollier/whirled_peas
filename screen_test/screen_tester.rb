require 'bundler/setup'
require 'whirled_peas'
require 'whirled_peas/frame/event_loop'
require 'whirled_peas/frame/producer'
require 'whirled_peas/graphics/debugger'
require 'whirled_peas/graphics/renderer'
require 'whirled_peas/graphics/screen'
require 'whirled_peas/settings/text_color'
require 'whirled_peas/utils/formatted_string'

module WhirledPeas
  class ScreenTester
    SCREEN_WIDTH = 80
    SCREEN_HEIGHT = 32

    def self.run_all
      base_dir = File.dirname(__FILE__)
      test_files = Dir.glob(File.join(base_dir, 'rendered', '**', '*.rb'))
      failures = {}
      pendings = Set.new
      puts "Running #{test_files.length} rendered screen test(s)"
      puts
      test_files.each do |file|
        tester = new(file)
        if tester.pending?
          print Utils::FormattedString.new('.', Settings::TextColor::YELLOW)
          pendings << file
        elsif tester.failed?
          print Utils::FormattedString.new('.', Settings::TextColor::RED)
          failures[file] = tester.error
        else
          print Utils::FormattedString.new('.', Settings::TextColor::GREEN)
        end
        STDOUT.flush
      end
      puts
      puts if pendings.count > 0
      pendings.each do |file|
        puts Utils::FormattedString.new("PENDING: #{file}", Settings::TextColor::YELLOW)
      end
      puts if failures.count > 0
      failures.each do |file, error|
        puts Utils::FormattedString.new("Failed: #{file}:\n\n    #{error}\n", Settings::TextColor::RED)
      end

      if failures.count == 0
        puts
        puts Utils::FormattedString.new('No failures', Settings::TextColor::GREEN)
      else
        exit(1)
      end
    end

    def self.update_all
      base_dir = File.dirname(__FILE__)
      test_files = Dir.glob(File.join(base_dir, 'rendered', '**', '*.rb'))
      test_files.each do |file|
        tester = new(file)
        if tester.pending?
          tester.ask_pending
        elsif tester.failed?
          tester.ask_failed
        end
      end
    end

    attr_reader :error

    def initialize(test_file)
      @full_test_file = test_file[0] == '/' ? test_file : File.join(Dir.pwd, test_file)
      raise ArgumentError, "File not found: #{test_file}" unless File.exist?(@full_test_file)
      @test_file = test_file.sub(File.dirname(__FILE__), '')[1..-1]
      @full_output_file = @full_test_file.sub(/\.rb$/, '.frame')
      @output_file = @full_output_file.sub(File.dirname(__FILE__), '')[1..-1]
    end

    def pending?
      !File.exist?(full_output_file)
    end

    def failed?
      if rendered != File.read(full_output_file)
        @error = 'Rendered output does not match saved output'
      end
      !@error.nil?
    end

    def view
      with_template_factory do |template_factory|
        render_screen(template_factory, STDOUT)
      end
    end

    def debug
      with_template_factory do |template_factory|
        render_screen(template_factory, StringIO.new)
      end
    end

    def template
      with_template_factory do |template_factory|
        template = template_factory.build('Test', {})
        puts Graphics::Debugger.new(template).debug
      end
    end

    def save
      if File.exist?(full_output_file)
        puts "Existing output file found: #{full_output_file}"
        puts "overwriting..."
      else
        puts "Writing output to file: #{full_output_file}"
      end

      with_template_factory do |template_factory|
        File.open(full_output_file, 'w') do |file|
          render_screen(template_factory, file)
        end
      end
    end

    def ask_pending
      puts Utils::FormattedString.new("Frame file does not exist for #{test_file}", Settings::TextColor::YELLOW)
      print 'View rendered frame? [Y/n/q] '
      STDOUT.flush
      response = STDIN.gets.strip.downcase
      case response
      when 'q'
        exit
      when 'n'
        return
      end
      print rendered
      STDOUT.flush
      ask_to_save
    end

    def ask_failed
      puts Utils::FormattedString.new("Output from test does not match saved output for #{test_file}", Settings::TextColor::RED)
      print 'View expected output? [Y/q] '
      STDOUT.flush
      exit if 'q' == STDIN.gets.strip.downcase
      print File.read(full_output_file)
      print 'View actual output? [Y/q] '
      STDOUT.flush
      exit if 'q' == STDIN.gets.strip.downcase
      print rendered
      STDOUT.flush
      ask_to_save
    end

    private

    attr_reader :full_test_file, :test_file, :full_output_file, :output_file

    def ask_to_save
      print "Save actual as the expected test output (#{output_file})? [y/N/q] "
      STDOUT.flush
      response = STDIN.gets.strip.downcase
      print Utils::Ansi.cursor_pos(left: 0, top: 0)
      print Utils::Ansi.clear_down
      if response == 'y'
        File.open(full_output_file, 'w') { |file| file.print(rendered) }
        puts "Saved to #{output_file}"
      elsif response == 'q'
        puts 'Exiting'
        exit
      else
        puts 'Skipped'
      end
    end

    def rendered
      @rendered ||= begin
        string_io = StringIO.new
        with_template_factory do |template_factory|
          render_screen(template_factory, string_io)
        end
        string_io.string
      end
    end

    def with_template_factory(&block)
      require full_test_file
      raise 'TemplateFactory must be defined' unless defined?(TemplateFactory)
      yield TemplateFactory.new
    ensure
      Object.send(:remove_const, :TemplateFactory)
    end

    def render_screen(template_factory, output)
      screen = Graphics::Screen.new(output: output, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
      consumer = Frame::EventLoop.new(
        template_factory, screen: screen, refresh_rate: 100000
      )
      Frame::Producer.produce(consumer) do |producer|
        producer.send_frame('test', args: {})
      end
    end
  end
end
