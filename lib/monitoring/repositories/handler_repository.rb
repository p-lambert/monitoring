module Monitoring
  module Repositories
    class HandlerRepository
      def initialize
        @data = {}
      end

      def add(name, callable)
        data[name] = callable
      end

      def get(*handlers)
        data.values_at(*handlers).compact
      end

      private

      attr_reader :data
    end
  end
end
