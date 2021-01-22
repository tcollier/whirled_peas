module WhirledPeas
  class Config
    attr_writer :driver, :template_factory
    attr_accessor :loading_template_factory

    def driver
      unless @driver
        raise ConfigurationError, 'driver must be configured'
      end
      @driver
    end

    def template_factory
      unless @template_factory
        raise ConfigurationError, 'template_factory must be configured'
      end
      @template_factory
    end
  end
  private_constant :Config
end
