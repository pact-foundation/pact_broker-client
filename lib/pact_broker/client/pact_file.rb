require 'json'

module PactBroker
  module Client
    class PactFile
      def initialize path
        @path = path
      end

      def pact_name
        "#{consumer_name}/#{provider_name} pact"
      end

      def consumer_name
        pact_contents[:consumer][:name]
      end

      def provider_name
        pact_contents[:provider][:name]
      end

      def pact_contents
        @contents ||= JSON.parse(read, symbolize_names: true)
      end

      def read
        @read ||= File.read(@path)
      end
    end
  end
end
