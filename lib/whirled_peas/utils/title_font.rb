module WhirledPeas
  module Utils
    module TitleFont
      PREFERRED_DEFAULT_FONT = :ansishadow
      FONT_CACHE = File.join(ENV['HOME'] || '.', '.whirled_peas.fonts')

      class << self
        def validate!(font_key)
          return if font_key.nil?
          return font_key if fonts.key?(font_key)
          allowed = fonts.keys.map(&:inspect).sort
          message = "Unrecognized font: '#{font_key.inspect}', expecting one of #{allowed.join(', ')}"
          raise ArgumentError, message
        end

        def to_s(string, font_key)
          require 'ruby_figlet'
          RubyFiglet::Figlet.new(string, fonts[font_key]).to_s
        end

        def fonts
          return @fonts if @fonts
          File.exist?(FONT_CACHE) ? load_fonts_from_cache : load_fonts_from_figlet
          @fonts
        end

        def load_fonts_from_cache
          require 'json'
          @fonts = {}
          File.open(FONT_CACHE, 'r') do |fp|
            JSON.parse(fp.read).each do |key, value|
              @fonts[key.to_sym] = value
            end
          end
          @fonts
        end

        def load_fonts_from_figlet
          require 'ruby_figlet'
          require 'json'
          @fonts = {}
          RubyFiglet::Figlet.available.strip.split("\n").each do |font|
            # Load the font to be sure it exists on the system
            next unless available?(font)
            string_key = font.downcase.gsub(/\W/, '')
            string_key = "_#{string_key}" if string_key[0] !~ /[a-z]/
            string_key.gsub!(/\d+$/, '')
            next if @fonts.key?(string_key)
            @fonts[string_key.to_sym] = font
          end
          @fonts[:default] ||= @fonts[PREFERRED_DEFAULT_FONT] || @fonts.values.first
          File.open(FONT_CACHE, 'w') { |fp| fp.write(JSON.generate(@fonts)) }
          @fonts
        end

        private

        def available?(font)
          # Figlet's font loader prints to STDOUT if the font file is not found.
          # Temporarily redirect STDOUT to /dev/null while the font file is loaded
          # then remove the redirect in an ensure block. Also, if a font file is
          # not available, a SystemExit is raise :/
          original_stdout = $stdout.clone
          $stdout.reopen(File.new('/dev/null', 'w'))
          RubyFiglet::Figlet.new('Text', font)
          true
        rescue SystemExit, NoMethodError
          false
        ensure
          $stdout.reopen(original_stdout)
        end
      end
    end
  end
end
