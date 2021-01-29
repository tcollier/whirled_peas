require 'logger'

module WhirledPeas
  class Config
    # Refreshed rate measured in frames per second
    DEFAULT_REFRESH_RATE = 30

    DEFAULT_LOG_LEVEL = Logger::INFO
    DEFAULT_LOG_FILE = 'whirled_peas.log'

    # This formatter expects a loggers to send `progname` in each log call. This value
    # should be an all uppercase version of the module or class that is invoking the
    # logger. Ruby's logger supports setting this value on a per-log statement basis
    # when the log message is passed in through a block:
    #
    #   logger.<level>(progname, &block)
    #
    # E.g.
    #
    #   class Foo
    #     def bar
    #       logger.warn('FOO') { 'Something fishy happened in #bar' }
    #     end
    #   end
    #
    # The block format also has the advantage that the evaluation of the block only
    # occurs if the message gets logged. So expensive to calculate debug statements
    # will not impact the performance of the application if the log level is INFO or
    # higher.
    DEFAULT_FORMATTER = proc do |severity, datetime, progname, msg|
      # Convert an instance of an exception into a nicely formatted message string
      if msg.is_a?(Exception)
        msg = %Q(#{msg.class}: #{msg.to_s}\n    #{msg.backtrace.join("\n    ")})
      end
      "[#{severity}] #{datetime.strftime('%Y-%m-%dT%H:%M:%S.%L')} (#{progname}) - #{msg}\n"
    end

    attr_writer :application, :template_factory, :refresh_rate, :log_level, :log_formatter, :log_file

    def application
      unless @application
        raise ConfigurationError, 'application must be configured'
      end
      @application
    end

    def driver
      puts 'Using legacy `driver` config var'
      @application
    end

    def driver=(application)
      puts 'Using legacy `driver=` config var'
      @application = application
    end

    def template_factory
      unless @template_factory
        raise ConfigurationError, 'template_factory must be configured'
      end
      @template_factory
    end

    def refresh_rate
      @refresh_rate || DEFAULT_REFRESH_RATE
    end

    def log_level
      @log_level || DEFAULT_LOG_LEVEL
    end

    def log_formatter
      @log_formatter || DEFAULT_FORMATTER
    end

    def log_file
      @log_file || DEFAULT_LOG_FILE
    end
  end
  private_constant :Config
end
