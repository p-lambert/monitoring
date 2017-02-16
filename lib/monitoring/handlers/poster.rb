require 'uri'
require 'net/http'
require 'net/https'

module Monitoring
  module Handlers
    class Poster
      def initialize(uri, options = {}, &block)
        @uri = URI(uri)
        @options = DEFAULT_HEADERS.merge(options)
        @body_proc = block if block_given?
      end

      def call(result)
        request = Net::HTTP::Post.new(uri, options)
        request.body = generate_payload(result)

        session = Net::HTTP.new(uri.hostname, uri.port)
        session.use_ssl = uri.instance_of?(URI::HTTPS)
        session.request(request)
      end

      private

      def body(_)
        fail(NotImplementedError)
      end

      attr_reader :uri, :options, :body_proc

      def generate_payload(result)
        generator = body_proc || method(:body)
        generator.call(result).to_json
      end

      DEFAULT_HEADERS = { 'Content-Type' => 'application/json' }.freeze
      private_constant :DEFAULT_HEADERS
    end
  end
end
