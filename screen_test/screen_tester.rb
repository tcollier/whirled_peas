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
      failure_count = 0
      test_files.each do |f|
        tester = new(f)
        tester.run
        failure_count += 1 if tester.failed?
      end
      if failure_count == 0
        puts "No failures"
      else
        puts "#{failure_count} render spec(s) failed"
        exit(1)
      end
    end

    def initialize(test_file)
      @test_file = test_file[0] == '/' ? test_file : File.join(Dir.pwd, test_file)
      raise ArgumentError, "File not found: #{@test_file}" unless File.exist?(@test_file)
      @output_file = @test_file.sub(/\.rb$/, '.frame')
      @failed = false
    end

    def failed?
      @failed
    end

    def run
      return pending(test_file) unless File.exist?(output_file)

      string_io = StringIO.new
      with_template_factory do |template_factory|
        render_screen(template_factory, string_io)
      end

      if string_io.string != File.read(output_file)
        return failure(test_file, 'Rendered output does not match saved output')
      end
      puts Utils::FormattedString.new('PASS', Settings::TextColor::GREEN)
    rescue => e
      failure(test_file, e.message)
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

    def with_template_factory(&block)
      require test_file
      raise 'TemplateFactory must be defined' unless defined?(TemplateFactory)
      yield TemplateFactory.new
    ensure
      Object.send(:remove_const, :TemplateFactory)
    end

    def render_screen(template_factory, output)
      screen = Graphics::Screen.new(output)
      consumer = Frame::EventLoop.new(template_factory, screen: screen)
      Frame::Producer.produce(consumer) do |producer|
        producer.send_frame('test', args: {})
      end
    end

    def pending(test_file)
      puts "#{Utils::FormattedString.new('PENDING', Settings::TextColor::YELLOW)}: No output for #{test_file}"
    end

    def failure(test_file, message)
      @failed = true
      puts "#{Utils::FormattedString.new('FAILURE', Settings::TextColor::RED)}: #{message} #{test_file}"
    end
  end
end
