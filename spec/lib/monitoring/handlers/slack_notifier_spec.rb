require 'spec_helper'

module Monitoring
  module Handlers
    RSpec.describe SlackNotifier do
      subject(:notifier) do
        described_class.new('http://hooks.slack.com/services/T00000000')
      end

      before { stub_request(:post, 'hooks.slack.com/services/T00000000') }

      describe '#call' do
        subject(:call) { notifier.call(result) }

        let(:result) { Result.new(:redis, SUCCESS, 'OK') }

        let(:expected_body) do
          {
            username: 'application_name',
            text: ':white_check_mark: *[redis]* OK',
            mrkdwn: true
          }
        end

        it 'sends a POST request with a message payload' do
          call

          expect(WebMock)
            .to have_requested(:post, 'hooks.slack.com/services/T00000000')
            .with(body: expected_body)
        end

        context 'result is a failure' do
          let(:result) { Result.new(:redis, FAILURE, 'FAILURE') }

          it 'notifies everyone in the channel' do
            call

            expect(WebMock)
              .to have_requested(:post, 'hooks.slack.com/services/T00000000')
              .with(body: /<!here>/)
          end
        end
      end
    end
  end
end
