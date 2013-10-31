module PactBroker
  module ClientSupport
    class PublishPacts

      def initialize pact_broker_client, pacts, consumer_version
        @pact_broker_client = pact_broker_client
        @pacts = pacts
        @consumer_version = consumer_version
      end

      def call
        @all_successful = true
        validate
        @pacts.each do | pact |
          publish_pact pact
        end
        @all_successful
      end

      def publish_pact pact
        begin
          @pact_broker_client.pacticipants.versions.pacts.publish(pact_json: File.read(pact), consumer_version: @consumer_version)
        rescue => e
          @all_successful = false
          $stderr.puts "Failed to publish pact: #{pact} due to error: #{e.to_s}\n#{e.backtrace.join("\n")}"
        end
      end

      def validate

      end

    end
  end
end
