require 'pact_broker/client/base_command'
require "pact_broker/client/matrix/resource"
require "pact_broker/client/matrix"

module PactBroker
  module Client
    class Matrix < BaseClient
      class Query < PactBroker::Client::BaseCommand

        def call
          matrix_entity = create_entry_point("#{pact_broker_client_options[:pact_broker_base_url]}/matrix", pact_broker_client_options).get!(query_params)
          Matrix::Resource.new(JSON.parse(matrix_entity.response.raw_body, symbolize_names: true))
        end

        private

        attr_reader :action, :response_entity


        def selectors
          params[:selectors]
        end

        def matrix_options
          @matrix_options ||= params[:matrix_options] ||{}
        end

        def query_params
          latestby = selectors.size == 1 ? 'cvp' : 'cvpv'
          query = {
            q: convert_selector_hashes_to_params(selectors),
            latestby: latestby
          }.merge(query_options)
        end

        def query_options
          opts = {}
          if matrix_options.key?(:success)
            opts[:success] = [*matrix_options[:success]]
          end
          opts[:limit] = matrix_options[:limit] if matrix_options[:limit]
          opts[:environment] = matrix_options[:to_environment] if matrix_options[:to_environment]
          if matrix_options[:to_tag]
            opts[:latest] = 'true'
            opts[:tag] = matrix_options[:to_tag]
          elsif matrix_options[:with_main_branches]
            opts[:latest] = 'true'
            opts[:mainBranch] = 'true'
          elsif selectors.size == 1 && !matrix_options[:to_environment]
            opts[:latest] = 'true'
          end
          if matrix_options[:ignore_selectors] && matrix_options[:ignore_selectors].any?
            opts[:ignore] = convert_selector_hashes_to_params(matrix_options[:ignore_selectors])
          end
          opts
        end

        def convert_selector_hashes_to_params(selectors)
          selectors.collect do |selector|
            { pacticipant: selector[:pacticipant] }.tap do | hash |
              hash[:version] = selector[:version] if selector[:version]
              hash[:latest] = 'true' if selector[:latest]
              hash[:tag] = selector[:tag] if selector[:tag]
              hash[:branch] = selector[:branch] if selector[:branch]
              hash[:mainBranch] = 'true' if selector[:main_branch]
            end
          end
        end

        def result_message
          if json_output?
            response_entity.response.raw_body
          else
            green("Pacticipant \"#{params[:name]}\" #{action} in #{pact_broker_name}")
          end
        end
      end
    end
  end
end
