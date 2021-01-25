require 'whirled_peas/utils/ansi'

require_relative 'color'

module WhirledPeas
  module Settings
    class BgColor < Color
      BG_OFFSET = 10
      private_constant :BG_OFFSET

      BLACK = new(Utils::Ansi::BLACK + BG_OFFSET)
      RED = new(Utils::Ansi::RED + BG_OFFSET)
      GREEN = new(Utils::Ansi::GREEN + BG_OFFSET)
      YELLOW = new(Utils::Ansi::YELLOW + BG_OFFSET)
      BLUE = new(Utils::Ansi::BLUE + BG_OFFSET)
      MAGENTA = new(Utils::Ansi::MAGENTA + BG_OFFSET)
      CYAN = new(Utils::Ansi::CYAN + BG_OFFSET)
      WHITE = new(Utils::Ansi::WHITE + BG_OFFSET)
      GRAY = BLACK.bright
    end
  end
end
