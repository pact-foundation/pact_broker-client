# Need Versions class to extend BaseClient until we can remove the old Versions code
require 'pact_broker/client/base_client'
require 'table_print'

module PactBroker
  module Client
    class Versions < BaseClient
      class JsonFormatter
        def self.call(version)
          JSON.pretty_generate(version)
        end
      end
    end
  end
end
