require 'forwardable'

module Monitoring
  module Repositories
    class ProbeRepository
      extend Forwardable
      def_delegators :data, :each, :to_enum

      def initialize
        @data = {}
      end

      def add(name, callable = nil, handlers = nil, &block)
        probe = callable || block
        probe.respond_to?(:call) || fail(ArgumentError)

        data[name] = [probe, *Array(handlers)]
      end

      private

      attr_reader :data
    end
  end
end
