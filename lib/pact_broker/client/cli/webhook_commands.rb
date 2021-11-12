module PactBroker
  module Client
    module CLI
      # Thor::Error will have its backtrace hidden
      class WebhookCreationError < ::Thor::Error; end

      module WebhookCommands
        def self.included(thor)
          thor.class_eval do

            no_commands do
              def self.shared_options_for_webhook_commands
                method_option :request, banner: "METHOD", aliases: "-X", desc: "Webhook HTTP method", required: true
                method_option :header, aliases: "-H", type: :array, desc: "Webhook Header"
                method_option :data, aliases: "-d", desc: "Webhook payload (file or string)"
                method_option :user, aliases: "-u", desc: "Webhook basic auth username and password eg. username:password"
                method_option :consumer, desc: "Consumer name"
                method_option :consumer_label, desc: "Consumer label, mutually exclusive with consumer name"
                method_option :provider, desc: "Provider name"
                method_option :provider_label, desc: "Provider label, mutually exclusive with provider name"
                method_option :description, desc: "Webhook description"
                method_option :contract_content_changed, type: :boolean, desc: "Trigger this webhook when the pact content changes"
                method_option :contract_published, type: :boolean, desc: "Trigger this webhook when a pact is published"
                method_option :provider_verification_published, type: :boolean, desc: "Trigger this webhook when a provider verification result is published"
                method_option :provider_verification_failed, type: :boolean, desc: "Trigger this webhook when a failed provider verification result is published"
                method_option :provider_verification_succeeded, type: :boolean, desc: "Trigger this webhook when a successful provider verification result is published"
                method_option :contract_requiring_verification_published, type: :boolean, desc: "Trigger this webhook when a contract is published that requires verification"
                method_option :team_uuid, banner: "UUID", desc: "UUID of the Pactflow team to which the webhook should be assigned (Pactflow only)"
                shared_authentication_options
              end
            end

            shared_options_for_webhook_commands

            desc 'create-webhook URL', 'Creates a webhook using the same switches as a curl request.'
            long_desc File.read(File.join(File.dirname(__FILE__), 'create_webhook_long_desc.txt'))
            def create_webhook webhook_url
              run_webhook_commands webhook_url
            end

            shared_options_for_webhook_commands
            method_option :uuid, type: :string, required: true, desc: "Specify the uuid for the webhook"

            desc 'create-or-update-webhook URL', 'Creates or updates a webhook with a provided uuid and using the same switches as a curl request.'
            long_desc File.read(File.join(File.dirname(__FILE__), 'create_or_update_webhook_long_desc.txt'))
            def create_or_update_webhook webhook_url
              run_webhook_commands webhook_url
            end

            desc 'test-webhook', 'Test the execution of a webhook'
            method_option :uuid, type: :string, required: true, desc: "Specify the uuid for the webhook"
            shared_authentication_options
            def test_webhook
              require 'pact_broker/client/webhooks/test'
              result = PactBroker::Client::Webhooks::Test.call(options, pact_broker_client_options)
              $stdout.puts result.message
            end

            no_commands do

              def parse_webhook_events
                events = []
                events << 'contract_content_changed' if options.contract_content_changed
                events << 'contract_published' if options.contract_published
                events << 'provider_verification_published' if options.provider_verification_published
                events << 'provider_verification_succeeded' if options.provider_verification_succeeded
                events << 'provider_verification_failed' if options.provider_verification_failed
                events << 'contract_requiring_verification_published' if options.contract_requiring_verification_published
                events
              end

              def parse_webhook_options(webhook_url)
                validate_mutual_exclusiveness_of_participant_name_and_label_options
                events = parse_webhook_events

                # TODO update for contract_requiring_verification_published when released
                if events.size == 0
                  raise WebhookCreationError.new("You must specify at least one of --contract-content-changed, --contract-published, --provider-verification-published, --provider-verification-succeeded or --provider-verification-failed")
                end

                username = options.user ? options.user.split(":", 2).first : nil
                password = options.user ? options.user.split(":", 2).last : nil

                headers = (options.header || []).each_with_object({}) { | header, headers | headers[header.split(":", 2).first.strip] = header.split(":", 2).last.strip }

                body = options.data
                if body && body.start_with?("@")
                  filepath = body[1..-1]
                  begin
                    body = File.read(filepath)
                  rescue StandardError => e
                    raise WebhookCreationError.new("Couldn't read data from file \"#{filepath}\" due to #{e.class} #{e.message}")
                  end
                end

                {
                  uuid: options.uuid,
                  description: options.description,
                  http_method: options.request,
                  url: webhook_url,
                  headers: headers,
                  username: username,
                  password: password,
                  body: body,
                  consumer: options.consumer,
                  consumer_label: options.consumer_label,
                  provider: options.provider,
                  provider_label: options.provider_label,
                  events: events,
                  team_uuid: options.team_uuid
                }
              end

              def run_webhook_commands webhook_url
                require 'pact_broker/client/webhooks/create'

                validate_credentials
                result = PactBroker::Client::Webhooks::Create.call(parse_webhook_options(webhook_url), options.broker_base_url, pact_broker_client_options)
                $stdout.puts result.message
                exit(1) unless result.success
              rescue PactBroker::Client::Error => e
                raise WebhookCreationError, "#{e.class} - #{e.message}"
              end

              def validate_mutual_exclusiveness_of_participant_name_and_label_options
                if options.consumer && options.consumer_label
                  raise WebhookCreationError.new("Consumer name (--consumer) and label (--consumer_label) options are mutually exclusive")
                end

                if options.provider && options.provider_label
                  raise WebhookCreationError.new("Provider name (--provider) and label (--provider_label) options are mutually exclusive")
                end
              end
            end
          end
        end
      end
    end
  end
end
