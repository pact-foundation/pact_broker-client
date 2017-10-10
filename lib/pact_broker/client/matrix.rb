require_relative 'base_client'

module PactBroker
  module Client
    class Matrix < BaseClient
      def get selectors
        query = {selectors: selectors}
        response = self.class.get("/matrix", query: query, headers: default_get_headers)

        response = handle_response(response) do
          JSON.parse(response.body, symbolize_names: true)[:matrix]
        end
      end

      def handle_response response
        if response.success?
          yield
        elsif response.code == 404
          raise PactBroker::Client::Error.new("Matrix resource not found at #{base_url}/matrix. Please upgrade your broker to the latest version.")
        else
          error_message = nil
          begin
            error_message = JSON.parse(response.body)['errors'].join("\n")
          rescue
            raise Error.new(response.body)
          end
          raise Error.new(error_message)
        end
      end
    end
  end
end
