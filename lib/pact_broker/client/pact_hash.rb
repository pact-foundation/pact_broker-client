require 'json'

module PactBroker
  module Client
    class PactHash < ::Hash
      def pact_name
        "#{consumer_name}/#{provider_name} pact"
      end

      def consumer_name
        self[:consumer][:name]
      end

      def provider_name
        self[:provider][:name]
      end
    end
  end
end
