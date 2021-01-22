module WhirledPeas
  module Frame
    # Abstract class for consuming frame events.
    class Consumer
      EOF = '__EOF__'

      def enqueue(name, duration, args)
        raise NotImplemented, "#{self.class} must implement #enqueue"
      end

      def running?
        @running == true
      end

      def start
        self.running = true
      end

      def stop
        enqueue(EOF, nil, {})
      end

      private

      attr_writer :running
    end

    private_constant :Consumer
  end
end
