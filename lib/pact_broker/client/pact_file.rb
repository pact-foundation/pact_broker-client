require 'json'
require 'pact_broker/client/pact_hash'

module PactBroker
  module Client
    class PactFile
      def initialize path
        @path = path
      end

      def path
        @path
      end

      def pact_name
        pact_hash.pact_name
      end

      def consumer_name
        pact_hash.consumer_name
      end

      def provider_name
        pact_hash.provider_name
      end

      def pact_hash
        @pact_hash ||= PactHash[JSON.parse(read, symbolize_names: true)]
      end

      def read
        @read ||= File.read(@path)
      end
    end
  end
end
