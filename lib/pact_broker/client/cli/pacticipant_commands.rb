module PactBroker
  module Client
    module CLI
      module PacticipantCommands
        PACTICIPANT_PARAM_NAMES = [:name, :display_name, :repository_url]

        def self.included(thor)
          thor.class_eval do
            desc 'create-or-update-pacticipant', 'Create or update pacticipant by name'
            method_option :name, type: :string, required: true, desc: "Pacticipant name"
            method_option :display_name, type: :string, desc: "Display name"
            method_option :repository_url, type: :string, required: false, desc: "The repository URL of the pacticipant"
            output_option_json_or_text
            shared_authentication_options
            verbose_option

            def create_or_update_pacticipant(*required_but_ignored)
              raise ::Thor::RequiredArgumentMissingError, "Pacticipant name cannot be blank" if options.name.strip.size == 0
              require 'pact_broker/client/pacticipants/create'
              params = PACTICIPANT_PARAM_NAMES.each_with_object({}) { | key, p | p[key] = options[key] }
              result = PactBroker::Client::Pacticipants2::Create.call(params, { verbose: options.verbose, output: options.output }, pact_broker_client_options)
              $stdout.puts result.message
              exit(1) unless result.success
            end
          end
        end
      end
    end
  end
end
