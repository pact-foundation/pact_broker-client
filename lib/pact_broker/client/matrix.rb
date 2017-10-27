require_relative 'base_client'

module PactBroker
  module Client
    class Matrix < BaseClient
      def get selectors
        query = convert_selector_hashes_to_params(selectors)
        response = self.class.get("/matrix", query: {q: query}, headers: default_get_headers)
        $stdout.puts("DEBUG: Response headers #{response.headers}") if verbose?
        $stdout.puts("DEBUG: Response body #{response}") if verbose?
        response = handle_response(response) do
          JSON.parse(response.body, symbolize_names: true)
        end
      end

      def handle_response response
        if response.success?
          yield
        elsif response.code == 401
          raise Error.new("Authentication failed")
        elsif response.code == 404
          raise Error.new("Matrix resource not found at #{base_url}/matrix. Please upgrade your broker to the latest version.")
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

      def convert_selector_hashes_to_params(selectors)
        selectors.collect{ |selector| {pacticipant: selector[:name], version: selector[:version]} }
      end
    end
  end
end
