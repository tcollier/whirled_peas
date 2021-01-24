require 'whirled_peas/frame/event_loop'
require 'whirled_peas/frame/producer'
require 'whirled_peas/graphics/debugger'
require 'whirled_peas/graphics/mock_screen'
require 'whirled_peas/graphics/renderer'
require 'whirled_peas/graphics/screen'
require 'whirled_peas/template/debugger'

module WhirledPeas
  class Debugger
    module Option
      DISABLE_SCREEN = :disable_screen
      RENDERED = :rendered
      TEMPLATE = :template

      VALID = [DISABLE_SCREEN, RENDERED, TEMPLATE]
    end
    private_constant :Option

    FRAME = 'debug'
    private_constant :FRAME

    def initialize(config_file, option=nil)
      unless option.nil? || Option::VALID.include?(option)
        message =
          "Invalid option: #{option}, expecting one of #{Option::VALID.join(', ')}"
        raise ArgumentError, message
      end
      @config_file = config_file
      @option = option
    end

    def debug
      require config_file
      if play_frame?
        screen = if disable_screen?
          Graphics::MockScreen.new(80, 40)
        else
          Graphics::Screen.new
        end
        consumer = Frame::EventLoop.new(
          WhirledPeas.config.template_factory, screen: screen
        )
        Frame::Producer.produce(consumer) do |producer|
          producer.send_frame(FRAME, args: {})
        end
        return
      end

      element = WhirledPeas.config.template_factory.build(FRAME, {})
      if print_rendered?
        painter = Graphics::Renderer.new(element, *Graphics::Screen.current_dimensions).painter
        puts Graphics::Debugger.new(painter).debug
      elsif print_template?
        puts Template::Debugger.new(element).debug
      end
    end

    private

    attr_reader :config_file, :option

    def play_frame?
      option.nil? || option == Option::DISABLE_SCREEN
    end

    def disable_screen?
      !option.nil? && option == Option::DISABLE_SCREEN
    end

    def print_rendered?
      !option.nil? && option == Option::RENDERED
    end

    def print_template?
      !option.nil? && option == Option::TEMPLATE
    end
  end

  private_constant :Debugger
end
