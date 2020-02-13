require 'thor'

module PactBroker
  module Client
    module CLI
      ##
      # Custom Thor task allows the following:
      #
      # `--option 1 --option 2` to be interpreted as `--option 1 2` (the standard Thor format for multiple value options)
      #
      class CustomThor < ::Thor

        no_commands do
          def self.start given_args = ARGV, config = {}
            super(massage_args(given_args))
          end

          def self.massage_args argv
            add_broker_config_from_environment_variables(turn_muliple_tag_options_into_array(argv))
          end

          def self.add_broker_config_from_environment_variables argv
            return argv if argv[0] == 'version' || argv[0] == 'help'

            new_argv = add_option_from_environment_variable(argv, 'broker-base-url', 'b', 'PACT_BROKER_BASE_URL')
            new_argv = add_option_from_environment_variable(new_argv, 'broker-username', 'u', 'PACT_BROKER_USERNAME')
            new_argv = add_option_from_environment_variable(new_argv, 'broker-token', 'k', 'PACT_BROKER_TOKEN')
            add_option_from_environment_variable(new_argv, 'broker-password', 'p', 'PACT_BROKER_PASSWORD')
          end

          def self.add_option_from_environment_variable argv, long_name, short_name, environment_variable_name
            option_options = ["--#{long_name}", "--#{long_name.gsub('-','_')}", "-#{short_name}"]
            if (argv & option_options).empty? && ENV[environment_variable_name]
              argv + ["--#{long_name}", ENV[environment_variable_name]]
            else
              argv
            end
          end

          # other task names, help, and the help shortcuts
          def self.known_first_arguments
            @known_first_arguments ||= tasks.keys + ::Thor::HELP_MAPPINGS + ['help']
          end

          def self.turn_muliple_tag_options_into_array argv
            new_argv = []
            opt_name = nil
            argv.each_with_index do | arg, i |
              if arg.start_with?('-')
                opt_name = arg
                existing = new_argv.find { | a | a.first == opt_name }
                if !existing
                  new_argv << [arg]
                end
              else
                if opt_name
                  existing = new_argv.find { | a | a.first == opt_name }
                  existing << arg
                  opt_name = nil
                else
                  new_argv << [arg]
                end
              end
            end
            new_argv.flatten
          end

          # If you try and generate a uuid, and the PACT_BROKER_... env vars are set, it will cause
          # generate_uuid to be called with parameters that it doesn't declare, and hence, throw an error.
          # This is a dirty hack that stops that happening!
          def self.ignored_potential_options_from_environment_variables
            method_option :broker_base_url, hide: true
            method_option :broker_username, hide: true
            method_option :broker_password, hide: true
            method_option :broker_token, hide: true
          end

          def self.shared_options_for_webhook_commands
            method_option :request, banner: "METHOD", aliases: "-X", desc: "HTTP method", required: true
            method_option :header, aliases: "-H", type: :array, desc: "Header"
            method_option :data, aliases: "-d", desc: "Data"
            method_option :user, aliases: "-u", desc: "Basic auth username and password eg. username:password"
            method_option :consumer, desc: "Consumer name"
            method_option :provider, desc: "Provider name"
            method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
            method_option :broker_username, desc: "Pact Broker basic auth username"
            method_option :broker_password, aliases: "-p", desc: "Pact Broker basic auth password"
            method_option :broker_token, aliases: "-k", desc: "Pact Broker bearer token"
            method_option :contract_content_changed, type: :boolean, desc: "Trigger this webhook when the pact content changes"
            method_option :provider_verification_published, type: :boolean, desc: "Trigger this webhook when a provider verification result is published"
            method_option :verbose, aliases: "-v", type: :boolean, default: false, required: false, desc: "Verbose output. Default: false"
          end
        end
      end
    end
  end
end