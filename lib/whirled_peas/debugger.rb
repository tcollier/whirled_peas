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
      PAINTER = :painter
      TEMPLATE = :template

      VALID = [DISABLE_SCREEN, PAINTER, TEMPLATE]
    end
    private_constant :Option

    FRAME = 'debug'
    private_constant :FRAME

    def initialize(template_file, option=nil)
      unless option.nil? || Option::VALID.include?(option)
        message =
          "Invalid option: #{option}, expecting one of #{Option::VALID.join(', ')}"
        raise ArgumentError, message
      end
      @template_file = template_file
      @option = option
    end

    def debug
      require template_file
      template_factory = TemplateFactory.new
      if play_frame?
        screen = if disable_screen?
          Graphics::MockScreen.new(80, 40)
        else
          Graphics::Screen.new
        end
        consumer = Frame::EventLoop.new(template_factory, screen: screen)
        Frame::Producer.produce(consumer) do |producer|
          producer.send_frame(FRAME, args: {})
        end
        return
      end

      template = template_factory.build(FRAME, {})
      if print_painter?
        painter = Graphics::Renderer.new(template, *Graphics::Screen.current_dimensions).painter
        puts Graphics::Debugger.new(painter).debug
      elsif print_template?
        puts Template::Debugger.new(template).debug
      end
    end

    private

    attr_reader :template_file, :option

    def play_frame?
      option.nil? || option == Option::DISABLE_SCREEN
    end

    def disable_screen?
      !option.nil? && option == Option::DISABLE_SCREEN
    end

    def print_painter?
      !option.nil? && option == Option::PAINTER
    end

    def print_template?
      !option.nil? && option == Option::TEMPLATE
    end
  end

  private_constant :Debugger
end
