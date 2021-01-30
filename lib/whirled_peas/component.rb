module WhirledPeas
  module Component
    module Factory
      class << self
        def register(name, klass)
          classes[name] = klass
        end

        def build(name)
          unless classes.key?(name)
            expected = classes.keys.join(', ')
            raise ArgumentError, "Unrecognized component: #{name.inspect}, expecting one of #{expected}"
          end
          @classes[name].new
        end

        private

        def classes
          return @classes if @classes
          @classes = {}
          Component.constants.each do |const|
            next if const == name
            klass = Component.const_get(const)
            next unless klass.is_a?(Class)
            name = const.to_s.gsub(/([a-z])([A-Z])/, '\1_\2').downcase.to_sym
            @classes[name] = klass
          end
          @classes
        end
      end
    end
  end
  private_constant :Component
end
