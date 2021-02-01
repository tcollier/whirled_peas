require 'bundler/setup'
require 'whirled_peas'
require 'whirled_peas/animator/producer'
require 'whirled_peas/animator/renderer_consumer'
require 'whirled_peas/device/rendered_frame'
require 'whirled_peas/device/screen'
require 'whirled_peas/graphics/debugger'
require 'whirled_peas/graphics/renderer'
require 'whirled_peas/settings/text_color'
require 'whirled_peas/settings/theme'
require 'whirled_peas/settings/theme_library'
require 'whirled_peas/utils/ansi'
require 'whirled_peas/utils/formatted_string'

module WhirledPeas
  # Useful code for managing the repository that should not be distributed with the gem
  module Tools
    # Return the parent directory N-levels up from the current file. If levels_up = 0 return
    # the directory of the current file. E.g.
    #
    #   parent_directory("/path/to/file.rb")
    #   # => "/path/to"
    #
    #   parent_directory("really/long/path/to/another/file.rb", 3)
    #   # => "really/long"
    #
    def self.parent_directory(file, levels_up=0)
      return File.dirname(file) if levels_up == 0
      parent_directory(File.dirname(file), levels_up - 1)
    end

    class ScreenTester
      # The output of a rendered frame is depenend upon the width and height of the screen.
      # Thus for the sake of reproduceability, the same width and height should be used for
      # all runs of the test. The values should be relatively small to discourage testing
      # complicated templates.
      SCREEN_WIDTH = 32
      SCREEN_HEIGHT = 24

      # Path to screen tests relative to the base of this repository
      SCREEN_TEST_DIR = 'screen_test'

      # Return the base directory of this repository
      def self.base_dir
        Tools.parent_directory(__FILE__, 3)
      end

      # Return all screen test files
      def self.test_files
        Dir.glob(File.join(base_dir, SCREEN_TEST_DIR, '**', '*.rb'))
      end

      def self.define_test_theme
        return if @defined_theme_library
        theme = Settings::Theme.new
        theme.color = :bright_white
        theme.bg_color = :black
        theme.border_color = :bright_white
        theme.axis_color = :bright_white
        Settings::ThemeLibrary.add(:test, theme)
        @defined_theme_library = true
      end

      # Run all screen tests that exist in the screen test directory
      def self.run_all
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
          puts Utils::FormattedString.new(
            "PENDING: #{file}",
            Settings::TextColor::YELLOW
            )
        end
        puts if failures.count > 0
        failures.each do |file, error|
          puts Utils::FormattedString.new(
            "Failed: #{file}:\n\n    #{error}\n",
            Settings::TextColor::RED
          )
        end

        if failures.count == 0
          puts
          puts Utils::FormattedString.new(
            'No failures',
            Settings::TextColor::GREEN
          )
          exit(0)
        else
          exit(1)
        end
      end

      # View rendered output for each pending test, giving the user the option to save the output
      # as the expected output
      def self.view_pending
        num_attempted = 0
        test_files.map do |file|
          tester = new(file)
          if tester.pending?
            puts "File: #{tester.test_file}"
            puts Utils::FormattedString.new(
              'Frame file does not exist', Settings::TextColor::YELLOW
            )
            print 'View rendered frame? [Y/n/q] '
            STDOUT.flush
            response = STDIN.gets.strip.downcase
            case response
            when 'q'
              exit
            when 'n'
              next
            end
            tester.ask_pending
            num_attempted += 1
          end
        end
        if num_attempted == 0
          puts 'No pending tests.'
        end
      end

      # View expected and rendered output for each failed test, giving the user the option
      # to overwrite the expected output with the rendered output
      def self.view_failed
        num_attempted = 0
        test_files.map do |file|
          tester = new(file)
          if tester.failed?
            puts "File: #{tester.test_file}"
            puts Utils::FormattedString.new(
              'Output from test does not match saved output', Settings::TextColor::RED
            )
            print 'View expected output? [Y/q] '
            STDOUT.flush
            exit if 'q' == STDIN.gets.strip.downcase
            tester.ask_failed
            num_attempted += 1
          end
        end
        if num_attempted == 0
          puts 'All rendered output matched expected.'
        end
      end

      attr_reader :error, :test_file

      def initialize(test_file)
        # Convert the input file path to an absolute path (if necessary)
        @full_test_file = test_file[0] == '/' ? test_file : File.join(Dir.pwd, test_file)
        raise ArgumentError, "File not found: #{test_file}" unless File.exist?(@full_test_file)

        # Remove the base directory from the full file path for a more readable file name
        @test_file = @full_test_file.sub(self.class.base_dir, '').sub(/^\//, '')

        # The output file has the same base name as the test file, but ends in `.frame`
        @full_output_file = @full_test_file.sub(/\.rb$/, '.frame')

        # Remove the base directory from the full file path for a more readable file name
        @output_file = @full_output_file.sub(self.class.base_dir, '').sub(/^\//, '')
      end

      # Display the rendered output of the test and
      #
      #   * If the expected ouptput matches the rendered output, simply display that output
      #   * If the expected ouptput does not match the rendered output, show the expect, then
      #     show the actual and give the user the option to overwrite expected with actual
      #   * If no expected output is saved for the test, give the user the option to save the
      #     rendered output as the expected output
      def view
        if pending?
          ask_pending
        elsif failed?
          ask_failed
        else
          puts rendered
          puts "Rendered output for #{test_file} matches expected."
        end
      end

      # Return true if no output file exists for the test
      def pending?
        !File.exist?(full_output_file)
      end

      # Return true if the rendered output does not match the expected outptu
      def failed?
        return false if pending?
        if rendered != File.read(full_output_file)
          @error = 'Rendered output does not match expected.'
        end
        !@error.nil?
      end

      # Enable the Graphics debugger to print out debug information. Also render the template,
      # but do not display it as rendering will clear the screen of debug output before the user
      # can read it.
      def debug
        with_template_factory do |template_factory|
          orig_debug = Graphics.debug
          Graphics.debug = true
          render_screen(template_factory, StringIO.new)
          Graphics.debug = orig_debug
        end
      end

      # Print out the template tree
      def template
        with_template_factory do |template_factory|
          template = template_factory.build('Test', {})
          puts Graphics::Debugger.new(template).debug
        end
      end

      def ask_pending
        puts rendered
        STDOUT.flush
        ask_to_save
      end

      def ask_failed
        puts File.read(full_output_file)
        puts "File: #{test_file}"
        print 'View actual output? [Y/q] '
        STDOUT.flush
        exit if 'q' == STDIN.gets.strip.downcase
        puts rendered
        STDOUT.flush
        ask_to_save
      end

      private

      attr_reader :full_test_file, :full_output_file, :output_file

      def ask_to_save
        puts "File: #{test_file}"
        print 'Save actual as the expected test output? [y/N/q] '
        STDOUT.flush
        response = STDIN.gets.strip.downcase
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
        self.class.define_test_theme
        require full_test_file
        raise 'TemplateFactory must be defined' unless defined?(TemplateFactory)
        yield TemplateFactory.new
      ensure
        Object.send(:remove_const, :TemplateFactory)
      end

      def render_screen(template_factory, output)
        Utils::Ansi.with_screen(output, width: SCREEN_WIDTH, height: SCREEN_HEIGHT) do
          strokes = Graphics::Renderer.new(
            template_factory.build('test', {}),
            SCREEN_WIDTH,
            SCREEN_HEIGHT
          ).paint
          Device::Screen.new(output: output).handle_rendered_frames(
            [Device::RenderedFrame.new(strokes, 0)]
          )
        end
      end
    end
  end
end
