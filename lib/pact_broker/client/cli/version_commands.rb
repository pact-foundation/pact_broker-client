module PactBroker
  module Client
    module CLI
      module VersionCommands
        def self.included(thor)
          thor.class_eval do
            desc "create-or-update-version", "Create or update pacticipant version by version number"
            method_option :pacticipant, required: true, aliases: "-a", desc: "The pacticipant name"
            method_option :version, required: true, aliases: "-e", desc: "The pacticipant version number"
            method_option :branch, required: false, desc: "The repository branch name"
            method_option :tag, aliases: "-t", type: :array, banner: "TAG", desc: "Tag name for pacticipant version. Can be specified multiple times."
            shared_authentication_options
            output_option_json_or_text
            verbose_option

            def create_or_update_version(*required_but_ignored)
              validate_create_version_params

              params = {
                pacticipant_name: options.pacticipant.strip,
                version_number: options.version.strip,
                branch_name: options.branch&.strip,
                tags: options.tag&.collect(&:strip)
              }

              execute_version_command(params, "Create")
            end


            no_commands do
              def execute_version_command(params, command_class_name)
                require "pact_broker/client/versions"
                command_options = { verbose: options.verbose, output: options.output }
                result = PactBroker::Client::Versions.const_get(command_class_name).call(params, command_options, pact_broker_client_options)
                $stdout.puts result.message
                exit(1) unless result.success
              end

              def validate_create_version_params
                raise ::Thor::RequiredArgumentMissingError, "Pacticipant name cannot be blank" if options.pacticipant.strip.size == 0
                raise ::Thor::RequiredArgumentMissingError, "Pacticipant version cannot be blank" if options.version.strip.size == 0
                raise ::Thor::RequiredArgumentMissingError, "Version branch cannot be blank" if options.branch && options.branch.strip.size == 0
                raise ::Thor::RequiredArgumentMissingError, "Version tag cannot be blank" if options.tag && options.tag.any?{ | tag | tag.strip.size == 0 }
              end
            end
          end
        end
      end
    end
  end
end
