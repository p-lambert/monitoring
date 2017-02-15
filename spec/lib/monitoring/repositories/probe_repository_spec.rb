require 'spec_helper'

module Monitoring
  module Repositories
    RSpec.describe ProbeRepository do
      subject(:repository) { described_class.new }

      it { is_expected.to respond_to(:each) }
      it { is_expected.to respond_to(:to_enum) }
      it { is_expected.to respond_to(:[]) }

      describe '#add' do
        subject(:add_probe) { repository.add(name, probe, handlers) }

        let(:name) { :probe_name }
        let(:probe) { ->{} }
        let(:handlers) { [:logger, :file_reporter] }

        it { is_expected.to be_truthy }

        it 'persists the information' do
          add_probe

          expect(repository[:probe_name])
            .to match([probe, :logger, :file_reporter])
        end

        context 'when an empty array of handlers is provided' do
          let(:handlers) { [] }

          it { is_expected.to be_truthy }

          it 'persists the information' do
            add_probe

            expect(repository[:probe_name]).to match([probe])
          end
        end

        context 'when probe does not respond to #call' do
          let(:probe) { :not_a_callable }

          it 'raises an argument error' do
            expect { add_probe }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
