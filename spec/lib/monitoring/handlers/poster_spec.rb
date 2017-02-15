require 'spec_helper'

module Monitoring
  module Handlers
    RSpec.describe Poster do
      subject(:poster) do
        described_class.new('http://www.vestorly.com') do |result|
          { name: result.probe, status: result.status }
        end
      end

      let(:result) { Result.new('probe_name', SUCCESS, 'foobar') }

      describe '#call' do
        subject(:post_result) { poster.call(result) }

        before { stub_request(:post, 'www.vestorly.com') }

        it 'performs a POST request using the body block provided' do
          post_result

          expect(WebMock)
            .to have_requested(:post, 'www.vestorly.com')
            .with(body: { name: 'probe_name', status: SUCCESS })
        end

        context 'subclassing' do
          let(:poster) { subclass.new('http://www.vestorly.com') }

          let(:subclass) do
            Class.new(described_class) do
              def body(result)
                { message: "OMG: #{result.probe}" }
              end
            end
          end

          it 'can also use a #body method' do
            post_result

            expect(WebMock)
              .to have_requested(:post, 'www.vestorly.com')
              .with(body: { message: 'OMG: probe_name' })
          end
        end
      end
    end
  end
end
