require 'spec_helper'
require 'tempfile'

module Monitoring
  RSpec.describe FileReport do
    subject(:file_report) { described_class.new(file_path) }

    let(:file_path) { Tempfile.new('report.json') }

    describe '#write' do
      subject(:write_report) { file_report.write(result) }

      let(:result) { Result.new(:foo, Monitoring::SUCCESS, 'OK') }

      let(:file_contents) { File.read(file_path) }

      it 'writes the result as a json-array entry' do
        write_report

        expect(file_contents).to eq([result].to_json)
      end

      context 'entry updating' do
        let(:expected_entries) do
          [
            { 'probe' => 'bar', 'status' => true, 'message' => 'message2' },
            { 'probe' => 'foo', 'status' => true, 'message' => 'message3' }
          ]
        end

        it 'updates an entry if it exists' do
          result1 = Result.new('foo', true, 'message1')
          result2 = Result.new('bar', true, 'message2')
          result3 = Result.new('foo', true, 'message3')

          file_report.write(result1)
          file_report.write(result2)
          file_report.write(result3)

          parsed_contents = JSON.parse(file_contents)
          expect(parsed_contents).to match(expected_entries)
        end
      end

      context 'concurrent writes' do
        let(:threaded_write) do
          ->(n) { Thread.new { file_report.write(Result.new(n, true, n)) } }
        end

        it 'allows multiple writes without corrupting the file' do
          1.upto(10).map(&threaded_write).each(&:join)

          expect { JSON.parse(file_contents) }.not_to raise_error
          expect(JSON.parse(file_contents).size).to eq(10)
        end
      end
    end
  end
end
