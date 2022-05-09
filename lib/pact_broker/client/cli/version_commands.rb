module PactBroker
  module Client
    module CLI
      class VersionCreationError < ::Thor::Error; end

      module VersionCommands
        def self.included(thor)
          thor.class_eval do
            method_option :pacticipant, required: true, aliases: "-a", desc: "The name of the pacticipant that the version belongs to."
            method_option :version, required: false, aliases: "-e", desc: "The pacticipant version number."
            method_option :latest, required: false, aliases: "-l", banner: '[TAG]', desc: "Describe the latest pacticipant version. Optionally specify a TAG to describe the latest version with the specified tag."
            method_option :output, aliases: "-o", desc: "json or table or id", default: 'table'
            shared_authentication_options

            desc 'describe-version', 'Describes a pacticipant version. If no version or tag is specified, the latest version is described.'
            def describe_version
              require 'pact_broker/client/versions/describe'

              validate_credentials
              latest = !options.latest.nil? || (options.latest.nil? && options.version.nil?)
              params = {
                pacticipant: options.pacticipant,
                version: options.version,
                latest: latest,
                tag: options.latest != "latest" ? options.latest : nil
              }
              opts = {
                output: options.output
              }
              result = PactBroker::Client::Versions::Describe.call(params, opts, options.broker_base_url, pact_broker_client_options)
              $stdout.puts result.message
              exit(1) unless result.success
            end


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
                branch_name: options.branch && options.branch.strip,
                tags: options.tag && options.tag.collect(&:strip)
              }

              execute_version_command(params, "Create")
            end

            desc 'create-version-tag', 'Add a tag to a pacticipant version'
            method_option :pacticipant, required: true, aliases: "-a", desc: "The pacticipant name"
            method_option :version, required: true, aliases: "-e", desc: "The pacticipant version"
            method_option :tag, aliases: "-t", type: :array, banner: "TAG", desc: "Tag name for pacticipant version. Can be specified multiple times."
            method_option :auto_create_version, type: :boolean, default: false, desc: "Automatically create the pacticipant version if it does not exist. Default: false"
            method_option :tag_with_git_branch, aliases: "-g", type: :boolean, default: false, required: false, desc: "Tag pacticipant version with the name of the current git branch. Default: false"
            shared_authentication_options

            def create_version_tag
              require 'pact_broker/client/create_tag'

              validate_credentials
              PactBroker::Client::CreateTag.call(
                options.broker_base_url,
                options.pacticipant,
                options.version,
                tags,
                options.auto_create_version,
                pact_broker_client_options)
            rescue PactBroker::Client::Error => e
              raise VersionCreationError.new(e.message)
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
