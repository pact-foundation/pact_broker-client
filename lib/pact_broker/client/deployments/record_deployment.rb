require 'pact_broker/client/deployments/record_release'
require "pact_broker/client/hash_refinements"

module PactBroker
  module Client
    module Deployments
      class RecordDeployment < PactBroker::Client::Deployments::RecordRelease
        using PactBroker::Client::HashRefinements

        def initialize(params, options, pact_broker_client_options)
          super
          @application_instance = params.fetch(:application_instance)
        end

        private

        attr_reader :application_instance

        def action
          "deployment"
        end

        def action_relation_name
          "pb:record-deployment"
        end

        def record_action_request_body
          # for backwards compatibility with old broker
          { applicationInstance: application_instance, target: application_instance }.compact
        end

        def result_text_message
          if application_instance
            "#{super} (application instance #{application_instance})"
          else
            super
          end
        end
      end
    end
  end
end
