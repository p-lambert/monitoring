require 'spec_helper'

module Monitoring
  module Repositories
    RSpec.describe HandlerRepository do
      subject(:repository) { described_class.new }

      describe '#add' do
        subject(:add_handler) { repository.add(name, callable) }

        let(:name) { :foo }
        let(:callable) { ->(_) {} }

        it { is_expected.to be_truthy }

        it 'persists the callable using the name as key' do
          add_handler

          expect(repository.values_at(name)).to eq([callable])
        end

        context 'when a callable class instance is provided' do
          let(:callable) { klass.new }

          let(:klass) do
            Class.new do
              def call(_); end
            end
          end

          it { is_expected.to be_truthy }
        end

        context 'when the provided object does not respond to #call' do
          let(:callable) { :foo }

          it 'raises an argument error' do
            expect { add_handler }.to raise_error(ArgumentError)
          end
        end

        context 'when callable object has arity different than one' do
          let(:callable) { ->{} }

          it 'raises an argument error' do
            expect { add_handler }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
