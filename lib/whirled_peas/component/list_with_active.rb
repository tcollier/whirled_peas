module WhirledPeas
  module Component
    class ListWithActive
      attr_accessor :active_index, :separator

      attr_reader :items

      attr_writer :flow, :viewport_size

      def items=(value)
        @items = value.map(&:to_s)
      end

      def flow
        @flow || :l2r
      end

      def total_size
        @total_size ||= if flow == :l2r
          size = separator.nil? ? 0 : (items.count - 1) * separator.length
          items.each { |item| size += item.length }
          size
        else
          items.count + (separator.nil? ? 0 : items.count - 1)
        end
      end

      def viewport_size
        @viewport_size || total_size
      end

      def compose(composer, settings)
        %i[items active_index].each do |required_attr|
          if send(required_attr).nil?
            raise ArgumentError, "Required field #{required_attr} missing"
          end
        end

        composer.add_box('ListWithActive') do |composer, settings|
          settings.flow = flow
          settings.align = :left
          settings.full_border
          if flow == :l2r
            settings.width = viewport_size
            active_start = separator.nil? ? 0 : active_index * separator.length
            items.first(active_index).each do |item|
              active_start += item.length
            end
            active_size = items[active_index].length
          else
            settings.height = viewport_size
            active_start = active_index + (separator.nil? ? 0 : active_index)
            active_size = 1
          end

          if viewport_size < total_size
            front_padding = (viewport_size - active_size) * 0.667
            offset = (active_start - front_padding).round
            if offset < 0
              offset = 0
            elsif offset > total_size - viewport_size
              offset = total_size - viewport_size
            end

            if flow == :l2r
              settings.content_start.left = -offset
              settings.scrollbar.horiz = true
            else
              settings.content_start.top = -offset
              settings.scrollbar.vert = true
            end
          end

          items.each.with_index do |item, index|
            composer.add_text { separator } if !separator.nil? && index > 0
            composer.add_text do |_, settings|
              if index == active_index
                settings.bg_color = :highlight
                settings.color = :highlight
              end
              item
            end
          end
        end
      end
    end
  end
end
