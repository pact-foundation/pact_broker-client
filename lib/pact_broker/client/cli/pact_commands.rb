require "pact_broker/client/hash_refinements"

module PactBroker
  module Client
    module CLI
      # Thor::Error will have its backtrace hidden
      class PactPublicationError < ::Thor::Error; end

      module PactCommands
        using PactBroker::Client::HashRefinements

        def self.included(thor)
          thor.class_eval do
            desc 'publish PACT_DIRS_OR_FILES ...', "Publish pacts to a Pact Broker."
            method_option :consumer_app_version, required: true, aliases: "-a", desc: "The consumer application version"
            method_option :branch, aliases: "-h", desc: "Repository branch of the consumer version"
            method_option :auto_detect_version_properties, type: :boolean, default: false, desc: "Automatically detect the repository branch from known CI environment variables or git CLI. Supports Buildkite, Circle CI, Travis CI, GitHub Actions, Jenkins, Hudson, AppVeyor, GitLab, CodeShip, Bitbucket and Azure DevOps."
            method_option :tag, aliases: "-t", type: :array, banner: "TAG", desc: "Tag name for consumer version. Can be specified multiple times."
            method_option :tag_with_git_branch, aliases: "-g", type: :boolean, default: false, required: false, desc: "Tag consumer version with the name of the current git branch. Supports Buildkite, Circle CI, Travis CI, GitHub Actions, Jenkins, Hudson, AppVeyor, GitLab, CodeShip, Bitbucket and Azure DevOps. Default: false"
            method_option :build_url, desc: "The build URL that created the pact"
            method_option :merge, type: :boolean, default: false, require: false, desc: "If a pact already exists for this consumer version and provider, merge the contents. Useful when running Pact tests concurrently on different build nodes."
            output_option_json_or_text
            shared_authentication_options

            def publish(*pact_files)
              require 'pact_broker/client/error'
              validate_credentials
              validate_pact_files(pact_files)
              result = publish_pacts(pact_files)
              $stdout.puts result.message
              exit(1) unless result.success
            rescue PactBroker::Client::Error => e
              raise PactPublicationError, "#{e.class} - #{e.message}"
            end

            desc 'list-latest-pact-versions', 'List the latest pact for each integration'
            shared_authentication_options
            output_option_json_or_table
            def list_latest_pact_versions(*required_but_ignored)
              require 'pact_broker/client/pacts/list_latest_versions'
              result = PactBroker::Client::Pacts::ListLatestVersions.call(options.broker_base_url, options.output, pact_broker_client_options)
              $stdout.puts result.message
              exit(1) unless result.success
            end

            no_commands do
              def validate_pact_files pact_files
                unless pact_files && pact_files.any?
                  raise ::Thor::RequiredArgumentMissingError, "No value provided for required pact_files"
                end
              end


              def publish_pacts pact_files
                require 'pact_broker/client/publish_pacts'

                write_options = options[:merge] ? { write: :merge } : {}
                consumer_version_params = {
                  number: options.consumer_app_version,
                  branch: branch,
                  tags: tags,
                  build_url: options.build_url,
                  version_required: (!!options.branch || !!options.build_url || explict_auto_detect_version_properties)
                }.compact

                PactBroker::Client::PublishPacts.call(
                  options.broker_base_url,
                  file_list(pact_files),
                  consumer_version_params,
                  { merge: options[:merge], output: options.output }.compact,
                  pact_broker_client_options.merge(write_options)
                )
              end

              def file_list pact_files
                require 'rake/file_list'

                correctly_separated_pact_files = pact_files.collect{ |path| path.gsub(/\\+/, '/') }
                paths = Rake::FileList[correctly_separated_pact_files].collect do | path |
                  if File.directory?(path)
                    Rake::FileList[File.join(path, "*.json")]
                  else
                    path
                  end
                end.flatten
                validate_pact_path_list(paths)
              end

              def validate_pact_path_list(paths)
                paths.collect do | path |
                  if File.exist?(path)
                    path
                  elsif path.start_with?("-")
                    raise Thor::Error.new("ERROR: pact-broker publish was called with invalid arguments #{[path]}")
                  else
                    raise Thor::Error.new("Specified pact file '#{path}' does not exist. This sometimes indicates one of the arguments has been specified with the wrong name and has been incorrectly identified as a file path.")
                  end
                end
              end

              def tags
                require 'pact_broker/client/git'

                t = [*options.tag]
                t << PactBroker::Client::Git.branch(raise_error: true) if options.tag_with_git_branch
                t.compact.uniq
              end

              def branch
                require 'pact_broker/client/git'

                if options.branch.nil? && options.auto_detect_version_properties
                  PactBroker::Client::Git.branch(raise_error: explict_auto_detect_version_properties)
                else
                  options.branch
                end
              end

              def explict_auto_detect_version_properties
                @explict_auto_detect_version_properties ||= ARGV.include?("--auto-detect-version-properties")
              end
            end
          end
        end
      end
    end
  end
end
