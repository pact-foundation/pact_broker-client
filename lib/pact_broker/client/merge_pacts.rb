require 'json'
require 'pact_broker/client/error'

module PactBroker
  module Client

    class PactMergeError < PactBroker::Client::Error; end

    module MergePacts
      extend self

      def call pact_hashes
        pact_hashes.reduce{|p1, p2| merge(p1, p2) }
      end

      # Accepts two hashes representing pacts, outputs a merged hash
      # Does not make any guarantees about order of interactions
      def merge original, additional
        new_pact = JSON.parse(original.to_json, symbolize_names: true)

        additional[:interactions].each do |new_interaction|
          # check to see if this interaction matches an existing interaction
          overwrite_index = original[:interactions].find_index do |original_interaction|
            same_description_and_state?(original_interaction, new_interaction)
          end

          # overwrite existing interaction if a match is found, otherwise appends the new interaction
          if overwrite_index
            if new_interaction == original[:interactions][overwrite_index]
              new_pact[:interactions][overwrite_index] = new_interaction
            else
              raise PactMergeError, almost_duplicate_message(original[:interactions][overwrite_index], new_interaction)
            end
          else
            new_pact[:interactions] << new_interaction
          end
        end

        new_pact
      end

      private

      def almost_duplicate_message(original, new_interaction)
        "Two interactions have been found with same description (#{new_interaction[:description].inspect}) and provider state (#{new_interaction[:providerState].inspect}) but a different request or response. " +
          "Please use a different description or provider state, or hard-code any random data.\n\n" +
          original.to_json + "\n\n" + new_interaction.to_json
      end

      def same_description_and_state? original, additional
        original[:description] == additional[:description] &&
          original[:providerState] == additional[:providerState]
      end
    end
  end
end
