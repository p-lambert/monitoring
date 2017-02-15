require 'forwardable'

module Monitoring
  module Repositories
    class HandlerRepository
      extend Forwardable
      def_delegators :data, :values_at, :delete

      def initialize
        @data = {}
      end

      def add(name, callable)
        check!(callable)

        data[name] = callable
      end

      private

      attr_reader :data

      def check!(obj)
        return if obj.is_a?(Proc) && obj.arity == 1
        return if obj.respond_to?(:call) && obj.method(:call).arity == 1

        fail(ArgumentError, 'object must respond to #call with one argument')
      end
    end
  end
end
