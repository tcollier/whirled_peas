require 'whirled_peas/utils/ansi'

require_relative 'color'

module WhirledPeas
  module Settings
    class TextColor < Color
      BLACK = new(Utils::Ansi::BLACK)
      RED = new(Utils::Ansi::RED)
      GREEN = new(Utils::Ansi::GREEN)
      YELLOW = new(Utils::Ansi::YELLOW)
      BLUE = new(Utils::Ansi::BLUE)
      MAGENTA = new(Utils::Ansi::MAGENTA)
      CYAN = new(Utils::Ansi::CYAN)
      WHITE = new(Utils::Ansi::WHITE)
      GRAY = BLACK.bright
    end
  end
end
