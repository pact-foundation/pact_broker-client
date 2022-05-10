require 'thor'
require 'pact_broker/client/hash_refinements'

module PactBroker
  module Client
    module CLI
      class AuthError < ::Thor::Error; end

      ##
      # Custom Thor task allows the following:
      #
      # `--option 1 --option 2` to be interpreted as `--option 1 2` (the standard Thor format for multiple value options)
      #
      class CustomThor < ::Thor
        using PactBroker::Client::HashRefinements

        no_commands do
          def self.exit_on_failure?
            true
          end

          def self.start given_args = ARGV, config = {}
            super(massage_args(given_args))
          end

          def self.massage_args argv
            add_broker_config_from_environment_variables(turn_muliple_tag_options_into_array(argv))
          end

          def self.add_broker_config_from_environment_variables argv
            return argv if argv[0] == 'help' || argv.empty?

            add_option_from_environment_variable(argv, 'broker-base-url', 'b', 'PACT_BROKER_BASE_URL')
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
            argv.each_with_index do | word, i |
              if word.start_with?('-')
                if word.include?('=')
                  opt_name, opt_value = word.split('=', 2)

                  existing = new_argv.find { | a | a.first == opt_name }
                  if existing
                    existing << opt_value
                  else
                    new_argv << [opt_name, opt_value]
                  end
                else
                  opt_name = word
                  existing = new_argv.find { | a | a.first == opt_name }
                  if !existing
                    new_argv << [word]
                  end
                end
              else
                if opt_name
                  existing = new_argv.find { | a | a.first == opt_name }
                  existing << word
                  opt_name = nil
                else
                  new_argv << [word]
                end
              end
            end
            new_argv.flatten
          end

          # If you try and generate a uuid, and the PACT_BROKER_... env vars are set, it will cause
          # generate_uuid to be called with parameters that it doesn't declare, and hence, throw an error.
          # This is a dirty hack that stops that happening!
          def self.ignored_and_hidden_potential_options_from_environment_variables
            method_option :broker_base_url, hide: true
            method_option :broker_username, hide: true
            method_option :broker_password, hide: true
            method_option :broker_token, hide: true
          end

          def self.shared_authentication_options
            method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
            method_option :broker_username, aliases: "-u", desc: "Pact Broker basic auth username"
            method_option :broker_password, aliases: "-p", desc: "Pact Broker basic auth password"
            method_option :broker_token, aliases: "-k", desc: "Pact Broker bearer token"
            method_option :verbose, aliases: "-v", type: :boolean, default: false, required: false, desc: "Verbose output. Default: false"
          end

          def self.verbose_option
            method_option :verbose, aliases: "-v", type: :boolean, default: false, required: false, desc: "Verbose output. Default: false"
          end

          def self.output_option_json_or_text
            method_option :output, aliases: "-o", desc: "json or text", default: 'text'
          end

          def self.output_option_json_or_table
            method_option :output, aliases: "-o", desc: "json or table", default: 'table'
          end

          def params_from_options(keys)
            keys.each_with_object({}) { | key, p | p[key] = options[key] }
          end

          def pact_broker_client_options
            client_options = { verbose: options.verbose, pact_broker_base_url: options.broker_base_url }
            client_options[:token] = options.broker_token || ENV['PACT_BROKER_TOKEN']
            if options.broker_username || ENV['PACT_BROKER_USERNAME']
              client_options[:basic_auth] = {
                  username: options.broker_username || ENV['PACT_BROKER_USERNAME'],
                  password: options.broker_password || ENV['PACT_BROKER_PASSWORD']
                }.compact
            end

            client_options.compact
          end

          def validate_credentials
            if options.broker_username && options.broker_token
              raise AuthError, "You cannot provide both a username/password and a bearer token. If your Pact Broker uses a bearer token, please remove the username and password configuration."
            end
          end
        end
      end
    end
  end
end
