require 'forwardable'

module Monitoring
  module Repositories
    class ProbeRepository
      extend Forwardable
      def_delegators :data, :each, :to_enum, :[]

      def initialize
        @data = {}
      end

      def add(name, probe, handlers)
        check!(probe)

        data[name] = [probe, *handlers]
      end

      private

      attr_reader :data

      def check!(probe)
        return if probe.respond_to?(:call)

        fail(ArgumentError, 'object must respond to #call')
      end
    end
  end
end
