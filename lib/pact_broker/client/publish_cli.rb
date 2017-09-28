require 'thor'
require 'pact_broker/client/publish_pacts'
require 'rake/file_list'

module PactBroker
  module Client

    # Thor::Error will have its backtrace hidden
    class PactPublicationError < ::Thor::Error; end

    class PublishCLI < Thor

      desc 'publish', "Publish pacts to a Pact Broker."
      method_option :pact_dir, required: true, aliases: "-d", desc: "The directory containing the pacts to publish"
      method_option :consumer_version, required: true, aliases: "-v", desc: "The consumer application version"
      method_option :broker_base_url, required: true, aliases: "-b", desc: "The base URL of the Pact Broker"
      method_option :username, aliases: "-u", desc: "Basic auth username for Pact Broker"
      method_option :password, aliases: "-p", desc: "Basic auth password for Pact Broker"
      method_option :tag, aliases: "-t", type: :array, desc: "Tag name(s) for consumer version. Can be space delimited or specified multiple times."

      def publish
        success = PactBroker::Client::PublishPacts.call(
          options[:broker_base_url],
          file_list,
          options[:consumer_version],
          tags,
          pact_broker_client_options
        )
        raise PactPublicationError, "One or more pacts failed to be published" unless success
      end

      default_task :publish

      no_commands do

        def self.turn_muliple_tag_options_into_array argv
          new_argv = []
          tags = []
          opt_name = nil
          argv.each_with_index do | arg, i |
            if arg.start_with?('-')
              opt_name = arg
              if opt_name != '--tag' && opt_name != '-t'
                new_argv << arg
              end
            else
              if opt_name == '--tag' || opt_name == '-t'
                tags << arg
              else
                new_argv << arg
              end
            end
          end

          if tags.any?
            new_argv << '--tag'
            new_argv.concat(tags)
          end
          new_argv
        end

        def file_list
          Rake::FileList["#{options[:pact_dir]}/*.json"]
        end

        def tags
          [*options[:tag]].compact
        end

        def pact_broker_client_options
          if options[:username]
            {
              username: options[:username],
              password: options[:password]
            }
          else
            {}
          end
        end
      end
    end
  end
end
