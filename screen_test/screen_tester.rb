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
    def self.run_all
      base_dir = File.dirname(__FILE__)
      test_files = Dir.glob(File.join(base_dir, 'rendered', '**', '*.rb'))
      failures = {}
      pendings = Set.new
      test_files.each do |f|
        tester = new(f)
        if tester.pending?
          print Utils::FormattedString.new('.', Settings::TextColor::YELLOW)
          pendings << f
        elsif tester.failed?
          print Utils::FormattedString.new('.', Settings::TextColor::RED)
          failures[f] = tester.error
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

    attr_reader :error

    def initialize(test_file)
      @test_file = test_file[0] == '/' ? test_file : File.join(Dir.pwd, test_file)
      raise ArgumentError, "File not found: #{@test_file}" unless File.exist?(@test_file)
      @output_file = @test_file.sub(/\.rb$/, '.frame')
    end

    def pending?
      !File.exist?(output_file)
    end

    def failed?
      render_and_compare
      !@error.nil?
    end

    def view
      with_template_factory do |template_factory|
        render_screen(template_factory, STDOUT)
      end
    end

    def debug
      with_template_factory do |template_factory|
        template = template_factory.build('Test', {})
        painter = Graphics::Renderer.new(template, *Graphics::Screen.current_dimensions).painter
        puts Graphics::Debugger.new(painter).debug
      end
    end

    def save_output
      if File.exist?(output_file)
        puts "Existing output file found: #{output_file}"
        puts "overwriting..."
      else
        puts "Writing output to file: #{output_file}"
      end


      with_template_factory do |template_factory|
        File.open(output_file, 'w') do |file|
          render_screen(template_factory, file)
        end
      end
    end

    private

    attr_reader :test_file, :output_file

    def render_and_compare
      string_io = StringIO.new
      with_template_factory do |template_factory|
        render_screen(template_factory, string_io)
      end

      if string_io.string != File.read(output_file)
        @error = 'Rendered output does not match saved output'
      end
    rescue => e
      @error = e.message
    end

    def with_template_factory(&block)
      require test_file
      raise 'TemplateFactory must be defined' unless defined?(TemplateFactory)
      yield TemplateFactory.new
    ensure
      Object.send(:remove_const, :TemplateFactory)
    end

    def render_screen(template_factory, output)
      screen = Graphics::Screen.new(output)
      consumer = Frame::EventLoop.new(
        template_factory, screen: screen, refresh_rate: 100000
      )
      Frame::Producer.produce(consumer) do |producer|
        producer.send_frame('test', args: {})
      end
    end
  end
end
