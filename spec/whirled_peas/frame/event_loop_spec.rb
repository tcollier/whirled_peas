require 'whirled_peas/frame/event_loop'

module WhirledPeas
  module Frame
    RSpec.describe EventLoop do
      TEST_REFRESH_RATE = 100000

      # RSpec doubles are not thread safe and some tests require multiple threads.
      class MockScreen
        attr_reader :painted, :refresh_count, :finalize_count

        def initialize
          @painted = []
          @refresh_count = 0
          @finalize_count = 0
        end

        def paint(template)
          @painted << template
        end

        def refresh
          @refresh_count += 1
        end

        def finalize
          @finalize_count += 1
        end
      end

      class MockTemplateFactory
        attr_reader :frames

        def initialize(template_name)
          @template_name = template_name
          @frames = []
        end

        def build(name, args)
          @frames << [name, args]
          @template_name
        end
      end

      class MockLoadingTemplateFactory
        attr_reader :build_count

        def initialize(template_name)
          @template_name = template_name
          @build_count = 0
        end

        def build
          @build_count += 1
          @template_name
        end
      end

      subject(:event_loop) do
        described_class.new(
          template_factory,
          loading_template_factory,
          refresh_rate: TEST_REFRESH_RATE,
          screen: screen
        )
      end

      let(:template_factory) { MockTemplateFactory.new('the-template') }
      let(:loading_template_factory) { nil }
      let(:screen) { MockScreen.new }

      it 'paints a template from the frame' do
        event_loop.enqueue('test', nil, foo: 'bar')
        event_loop.enqueue(described_class::EOF, 1, {})
        event_loop.start
        expect(template_factory.frames).to include(['test', foo: 'bar'])
      end

      it 'paints the template' do
        event_loop.enqueue('test', nil, foo: 'bar')
        event_loop.enqueue(described_class::EOF, 1, {})
        event_loop.start
        expect(screen.painted).to include('the-template')
      end

      it 'finalizes the screen' do
        event_loop.enqueue(described_class::EOF, 1, {})
        event_loop.start
        expect(screen.finalize_count).to eq(1)
      end

      context 'when template generation raises an error' do
        let(:error) { RuntimeError.new('Boom') }

        before do
          allow(template_factory).to receive(:build).and_raise(error)
        end

        it 'finalizes the screen' do
          event_loop.enqueue('test', 1, {})
          event_loop.start rescue nil
          expect(screen.finalize_count).to eq(1)
        end

        it 'raises the error' do
          expect do
            event_loop.enqueue('test', 1, {})
            event_loop.start
          end.to raise_error(error)
        end
      end

      context 'when a loading template factory is provided' do
        let(:loading_template_factory) do
          MockLoadingTemplateFactory.new('loading-template')
        end

        it 'paints the loading screen template' do
          loop_thread = Thread.new { event_loop.start }
          sleep(1.5 / TEST_REFRESH_RATE)
          event_loop.stop
          loop_thread.join
          expect(screen.painted).to include('loading-template')
        end
      end
    end
  end
end
