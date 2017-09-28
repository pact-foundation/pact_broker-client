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
      method_option :base_url, required: true, aliases: "-b"
      method_option :tag, aliases: "-t"
      method_option :username, aliases: "-u"
      method_option :password, aliases: "-p"

      def publish
        success = PactBroker::Client::PublishPacts.call(
          options[:base_url],
          file_list,
          options[:consumer_version],
          tags,
          pact_broker_client_options
        )
        raise PactPublicationError, "One or more pacts failed to be published" unless success
      end

      default_task :publish

      no_commands do
        def file_list
          Rake::FileList["#{options[:pact_dir]}/*.json"]
        end

        def tags
          [options[:tag]].compact
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
