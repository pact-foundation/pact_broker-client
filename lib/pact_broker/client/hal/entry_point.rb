require 'pact_broker/client/hal/link'

module PactBroker
  module Client
    module Hal
      class EntryPoint < Link
        def initialize(url, http_client)
          super({ "href" => url }, http_client)
        end
      end
    end
  end
end
