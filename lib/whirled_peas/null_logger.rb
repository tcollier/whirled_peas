module WhirledPeas
  class NullLogger
    def debug(*)
    end

    def error(*)
    end

    def fatal(*)
    end

    def info(*)
    end

    def warn(*)
    end
  end

  private_constant :NullLogger
end
