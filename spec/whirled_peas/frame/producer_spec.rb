require 'whirled_peas/frame/producer'

module WhirledPeas
  module Frame
    RSpec.describe Producer do
      describe '.produce' do
        subject(:producer) do
          instance_double(described_class, send_frame: nil, flush: nil)
        end

        let(:event_loop) do
          instance_double(EventLoop, start: nil, stop: nil)
        end
        let(:logger) { instance_double(Logger).as_null_object }

        before do
          allow(described_class)
            .to receive(:new)
            .with(event_loop, logger)
            .and_return(producer)
        end

        it 'starts the event_loop' do
          described_class.produce(event_loop, logger) { }
          expect(event_loop).to have_received(:start)
        end

        it 'yields the producer' do
          yielded = nil
          described_class.produce(event_loop, logger) do |value|
            yielded = value
          end
          expect(yielded).to eq(producer)
        end

        it 'sends an EOF' do
          described_class.produce(event_loop, logger) { }
          expect(producer).to have_received(:send_frame).with(Frame::EOF)
        end

        it 'flushes the producer' do
          described_class.produce(event_loop, logger) { }
          expect(producer).to have_received(:flush)
        end

        context 'when the driver raises an error' do
          let(:error) { RuntimeError.new('Unexpected Failure') }

          it 'stops the event_loop' do
            described_class.produce(event_loop, logger) { raise error } rescue nil
            expect(event_loop).to have_received(:stop)
          end

          it 'stops the event_loop' do
            expect do
              described_class.produce(event_loop, logger) { raise error }
            end.to raise_error(error)
          end
        end
      end

      describe '#flush' do
        subject(:producer) { described_class.new(event_loop) }

        let(:event_loop) { instance_double(EventLoop, enqueue: nil) }

        it 'enqueues sent events with the EventLoop' do
          producer.send_frame('frame-1', duration: 5)
          producer.send_frame('frame-2', args: { foo: 'bar' })
          producer.flush
          expect(event_loop).to have_received(:enqueue).with('frame-1', 5, {})
          expect(event_loop).to have_received(:enqueue).with('frame-2', nil, foo: 'bar')
        end
      end
    end
  end
end
