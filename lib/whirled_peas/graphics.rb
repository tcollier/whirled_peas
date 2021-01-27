module WhirledPeas
  module Graphics
    class << self
      attr_accessor :debug

      def debugger(string_or_proc)
        return unless @debug
        @debugger ||= Logger.new(STDOUT, level: Logger::DEBUG)
        if string_or_proc.is_a?(Proc)
          string = string_or_proc.call
        else
          string = string_or_proc
        end
        @debugger.debug(string)
      end
    end
  end
  private_constant :Graphics
end
