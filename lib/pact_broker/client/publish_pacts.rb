require 'term/ansicolor'
require 'pact_broker/client/hal_client_methods'
require 'base64'
require 'pact_broker/client/publish_pacts_the_old_way'

module PactBroker
  module Client
    class PublishPacts
      using PactBroker::Client::HashRefinements
      include HalClientMethods

      def self.call(pact_broker_base_url, pact_file_paths, consumer_version_params, pact_broker_client_options={})
        new(pact_broker_base_url, pact_file_paths, consumer_version_params, pact_broker_client_options).call
      end

      def initialize pact_broker_base_url, pact_file_paths, consumer_version_params, pact_broker_client_options={}
        @pact_broker_base_url = pact_broker_base_url
        @pact_file_paths = pact_file_paths
        @consumer_version_number = consumer_version_params[:number].respond_to?(:strip) ? consumer_version_params[:number].strip : consumer_version_params[:number]
        @branch = consumer_version_params[:branch]
        @build_url = consumer_version_params[:build_url]
        @tags = consumer_version_params[:tags] ? consumer_version_params[:tags].collect{ |tag| tag.respond_to?(:strip) ? tag.strip : tag } : []
        @version_required = consumer_version_params[:version_required]
        @pact_broker_client_options = pact_broker_client_options
      end

      def call
        validate
        if index_resource.can?("pb:publish-contracts")
          publish_pacts
          PactBroker::Client::CommandResult.new(success?, message)
        else
          PublishPactsTheOldWay.call(pact_broker_base_url, pact_file_paths, consumer_version_params, pact_broker_client_options)
        end
      end

      private

      attr_reader :pact_broker_base_url, :pact_file_paths, :consumer_version_number, :branch, :tags, :build_url, :pact_broker_client_options, :response_entities

      def request_body_for(consumer_name)
        {
          pacticipantName: consumer_name,
          versionNumber: consumer_version_number,
          tags: tags,
          branch: branch,
          buildUrl: build_url,
          contracts: contracts_for(consumer_name)
        }.compact
      end

      def publish_pacts
        @response_entities = consumer_names.collect do | consumer_name |
          index_resource._link("pb:publish-contracts").post(request_body_for(consumer_name))
        end
      end

      def success?
        response_entities.all?(&:success?)
      end

      def message
        response_entities.flat_map do | response_entity |
          if response_entity.success?
            response_entity.logs.collect do | log |
              colorized_message(log)
            end
          else
            ::Term::ANSIColor.red(response_entity.response.body.to_s)
          end
        end.join("\n")
      end

      def colorized_message(log)
        color = color_for_level(log["level"])
        if color
          ::Term::ANSIColor.send(color, log["message"])
        else
          log["message"]
        end
      end

      def color_for_level(level)
        case level
        when "warn" then :yellow
        when "error" then :red
        when "info" then :green
        else nil
        end
      end

      def contracts_for(consumer_name)
        pact_files_for(consumer_name).collect do | pact_file |
        end

        pact_files_for(consumer_name).group_by(&:pact_name).values.collect do | pact_files |
          $stderr.puts "Merging #{pact_files.collect(&:path).join(", ")}" if pact_files.size > 1
          pact_hash = PactHash[merge_contents(pact_files)]
          {
            role: "consumer",
            providerName: pact_hash.provider_name,
            specification: "pact",
            contentType: "application/json",
            content: Base64.strict_encode64(pact_hash.to_json)
          }
        end
      end

      def merge_contents(pact_files)
        MergePacts.call(pact_files.collect(&:pact_hash))
      end

      def pact_files
        @pact_files ||= pact_file_paths.collect{ |pact_file_path| PactFile.new(pact_file_path) }
      end

      def pact_files_for(consumer_name)
        pact_files.select{ | pact_file | pact_file.consumer_name == consumer_name }
      end

      def consumer_names
        pact_files.collect(&:consumer_name).uniq
      end

      def validate
        raise PactBroker::Client::Error.new("Please specify the consumer_version_number") unless (consumer_version_number && consumer_version_number.to_s.strip.size > 0)
        raise PactBroker::Client::Error.new("Please specify the pact_broker_base_url") unless (pact_broker_base_url && pact_broker_base_url.to_s.strip.size > 0)
        raise PactBroker::Client::Error.new("No pact files found") unless (pact_file_paths && pact_file_paths.any?)
      end
    end
  end
end
