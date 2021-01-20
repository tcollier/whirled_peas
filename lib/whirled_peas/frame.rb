require_relative 'frame/consumer'
require_relative 'frame/producer'

module WhirledPeas
  module Frame
    TERMINATE = '__term__'
    EOF = '__EOF__'

    DEFAULT_ADDRESS = 'localhost'
    DEFAULT_PORT = 8765
  end

  private_constant :Frame
end
