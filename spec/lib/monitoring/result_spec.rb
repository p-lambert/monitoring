require 'spec_helper'

module Monitoring
  RSpec.describe Result do
    subject(:result) { described_class.new(probe, status, message) }

    let(:probe) { :database }
    let(:status) { Monitoring::SUCCESS }
    let(:message) { 'OK' }

    describe '#probe' do
      subject(:probe_attribute) { result.probe }

      it { is_expected.to eq(:database) }
    end

    describe '#status' do
      subject(:status_attribute) { result.status }

      it { is_expected.to eq(Monitoring::SUCCESS) }
    end

    describe '#message' do
      subject(:message_attribute) { result.message }

      it { is_expected.to eq('OK') }
    end

    describe '#success?' do
      subject(:success?) { result.success? }

      it { is_expected.to be_truthy }

      context 'when status is FAILURE' do
        let(:status) { Monitoring::FAILURE }

        it { is_expected.to be_falsey }
      end
    end

    describe '#failure?' do
      subject(:error?) { result.failure? }

      it { is_expected.to be_falsey }

      context 'when status is FAILURE' do
        let(:status) { Monitoring::FAILURE }

        it { is_expected.to be_truthy }
      end
    end

    describe '#to_h' do
      subject(:to_json) { result.to_h }

      let(:expected_hash) do
        { 'database' => { 'status' => true, 'message' => 'OK' } }
      end

      it { is_expected.to eq(expected_hash) }
    end

    describe '#to_s' do
      subject(:to_s) { result.to_s }

      it { is_expected.to eq('probe=database status=true message=OK') }
    end

    describe 'object mutation' do
      it 'cannot be mutated' do
        expect { result.probe = 'NOT' }.to raise_error(/frozen/)
      end
    end

    describe '.generate' do
      subject(:generate) { described_class.generate(name, data) }

      let(:name) { :foo }

      let(:data) { described_class.new(:foo, SUCCESS, 'Custom message') }

      let(:failure) { described_class.new(:foo, FAILURE, 'FAILED') }

      it { is_expected.to eq(data) }

      context 'when data is false' do
        let(:data) { false }

        it { is_expected.to eq(failure) }
      end

      context 'when data is nil' do
        let(:data) { false }

        it { is_expected.to eq(failure) }
      end

      context 'when data is an empty string' do
        let(:data) { false }

        it { is_expected.to eq(failure) }
      end

      context 'when data is a non-string' do
        let(:data) { 'whatever' }

        it { is_expected.to eq(described_class.new(name, SUCCESS, 'whatever')) }
      end

      context 'when data is a FAILURE pair' do
        let(:data) { [FAILURE, 'custom'] }

        it { is_expected.to eq(described_class.new(name, FAILURE, 'custom')) }
      end

      context 'when data is a SUCCESS pair' do
        let(:data) { [SUCCESS, 'custom'] }

        it { is_expected.to eq(described_class.new(name, SUCCESS, 'custom')) }
      end

      context 'when data is anything else' do
        let(:data) { :anything_else }

        it { is_expected.to eq(described_class.new(name, SUCCESS, 'OK')) }
      end
    end
  end
end
