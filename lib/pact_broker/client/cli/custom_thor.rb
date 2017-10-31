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
        end
      end
    end
  end
end