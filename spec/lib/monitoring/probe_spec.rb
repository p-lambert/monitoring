require 'spec_helper'

module Monitoring
  RSpec.describe Probe do
    subject(:probe) { described_class.new(name, task, *handlers) }

    let(:name) { :probe_name }
    let(:task) { -> { [SUCCESS, 'OK'] } }
    let(:handlers) { [] }

    describe '#call' do
      subject(:call) { probe.call }

      it 'executes the probe task' do
        expect(task).to receive(:call)
        call
      end

      it { is_expected.to be_a(Result) }

      it { is_expected.to be_success }

      it 'generates a proper result object' do
        expect(call).to have_attributes(
          probe: :probe_name,
          status: SUCCESS,
          message: 'OK'
        )
      end

      context 'when task fails' do
        let(:task) { -> { fail('error message') } }

        it 'does not propagate the exception' do
          expect { call }.not_to raise_error
        end

        it 'generates a proper result object' do
          expect(call).to have_attributes(
            probe: :probe_name,
            status: FAILURE,
            message: 'error message'
          )
        end

        it { is_expected.to be_failure }
      end

      context 'when task times out' do
        let(:task) { -> { sleep(10) } }

        before { Monitoring.configuration.timeout = 0.2 }

        it 'does not propagate generate an exception' do
          expect { call }.not_to raise_error
        end

        it 'generates a proper result object' do
          expect(call).to have_attributes(
            probe: :probe_name,
            status: FAILURE,
            message: /execution expired/
          )
        end
      end

      context 'result handling' do
        let(:handlers) { [handler1, handler2] }
        let(:handler1) { ->(result) { fail('oops') } }
        let(:handler2) { ->(result) { 1+1 } }

        it 'calls all handlers with the task result' do
          expect(handler1).to receive(:call).with(an_instance_of(Result))
          expect(handler2).to receive(:call).with(an_instance_of(Result))

          call
        end
      end
    end
  end
end
