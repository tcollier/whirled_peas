require_relative 'frame/event_loop'
require_relative 'frame/producer'

module WhirledPeas
  module Frame
    TERMINATE = '__term__'
    EOF = '__EOF__'
  end

  private_constant :Frame
end
