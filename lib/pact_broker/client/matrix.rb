require_relative 'base_client'

module PactBroker
  module Client
    class Matrix < BaseClient
      def get selectors
        query = {selectors: selectors}
        response = self.class.get("/matrix", query: query, headers: default_get_headers)

        handle_response(response) do
          JSON.parse(response.body, symbolize_names: true)
        end
      end
    end
  end
end
