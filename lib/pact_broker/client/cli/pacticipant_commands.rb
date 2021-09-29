module PactBroker
  module Client
    module CLI
      module PacticipantCommands
        PACTICIPANT_PARAM_NAMES = [:name, :display_name, :main_branch, :repository_url]

        def self.included(thor)
          thor.class_eval do
            desc 'create-or-update-pacticipant', 'Create or update pacticipant by name'
            method_option :name, type: :string, required: true, desc: "Pacticipant name"
            method_option :display_name, type: :string, desc: "Display name"
            method_option :main_branch, type: :string, required: false, desc: "The main development branch of the pacticipant repository"
            method_option :repository_url, type: :string, required: false, desc: "The repository URL of the pacticipant"
            output_option_json_or_text
            shared_authentication_options
            verbose_option

            def create_or_update_pacticipant(*required_but_ignored)
              raise ::Thor::RequiredArgumentMissingError, "Pacticipant name cannot be blank" if options.name.strip.size == 0
              execute_pacticipant_command(params_from_options(PACTICIPANT_PARAM_NAMES), 'Create')
            end

            desc 'list-pacticipants', 'List pacticipants'
            output_option_json_or_text
            shared_authentication_options
            verbose_option
            def list_pacticipants
              execute_pacticipant_command(params_from_options(PACTICIPANT_PARAM_NAMES), 'List')
            end

            desc 'describe-pacticipant', "Describe a pacticipant"
            method_option :name, type: :string, required: true, desc: "Pacticipant name"
            output_option_json_or_text
            shared_authentication_options
            verbose_option
            def describe_pacticipant
              execute_pacticipant_command({ name: options.name }, 'Describe')
            end

            no_commands do
              def execute_pacticipant_command(params, command_class_name)
                require 'pact_broker/client/pacticipants'
                command_options = { verbose: options.verbose, output: options.output }
                result = PactBroker::Client::Pacticipants2.const_get(command_class_name).call(params, command_options, pact_broker_client_options)
                $stdout.puts result.message
                exit(1) unless result.success
              end
            end
          end
        end
      end
    end
  end
end
