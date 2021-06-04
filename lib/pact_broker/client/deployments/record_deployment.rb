require 'pact_broker/client/deployments/record_release'

module PactBroker
  module Client
    module Deployments
      class RecordDeployment < PactBroker::Client::Deployments::RecordRelease
        def initialize(params, options, pact_broker_client_options)
          super
          @target = params.fetch(:target)
        end

        private

        attr_reader :target

        def action
          "deployment"
        end

        def action_relation_name
          "pb:record-deployment"
        end

        def record_action_request_body
          { target: target }.compact
        end

        def result_text_message
          if target
            "#{super} (target #{target})"
          else
            super
          end
        end
      end
    end
  end
end
