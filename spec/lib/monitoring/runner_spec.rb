require 'spec_helper'
require 'timeout'

module Monitoring
  RSpec.describe Runner do
    subject(:runner) do
      described_class.new(probe_repository, handler_repository)
    end

    let(:probe_repository) do
      {
        probe1: [probe1_task, :handler1],
        probe2: [probe2_task]
      }
    end

    let(:handler_repository) do
      {
        handler1: handler1,
        handler2: handler2,
      }
    end

    let(:probe1_task) { ->{ sleep(0.5) } }
    let(:probe2_task) { ->{ sleep(0.5) } }
    let(:handler1) { ->(_) {} }
    let(:handler2) { ->(_) {} }

    describe '#call' do
      subject(:call) { runner.call }

      it 'instantiates `probe` objects with the proper params' do
        expect(Probe)
          .to receive(:new)
          .with(:probe1, probe1_task, handler1)
          .and_call_original

        expect(Probe)
          .to receive(:new)
          .with(:probe2, probe2_task, handler1, handler2)
          .and_call_original

        call
      end

      it 'executes things concurrently' do
        expect { Timeout::timeout(0.9) { call } }.not_to raise_error
      end
    end
  end
end
