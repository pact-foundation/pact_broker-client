require 'pact_broker/client/error'

module PactBroker
  module Client
    class Retry
      class RescuableError
        UNRESCUEABLE = [PactBroker::Client::Error]

        def self.===(e)
          case e
          when *UNRESCUEABLE then false
          else true
          end
        end
      end

      def self.while_error options = {}
        max_tries = options.fetch(:times, 3)
        tries = 0
        while true
          begin
            return yield
          rescue RescuableError => e
            tries += 1
            $stderr.puts "Error making request - #{e.class} #{e.message} #{e.backtrace.find{|l| l.include?('pact_broker-client')}}, attempt #{tries} of #{max_tries}"
            raise e if max_tries == tries
            sleep options.fetch(:sleep, 5)
          end
        end
      end

      def self.until_truthy_or_max_times options = {}
        max_tries = options.fetch(:times, 3)
        tries = 0
        verbose = options[:verbose]
        sleep_interval = options.fetch(:sleep, 5)
        sleep(sleep_interval) if options[:sleep_first]
        while true
          begin
            result = yield
            return result if max_tries < 2
            if options[:condition]
              condition_result = options[:condition].call(result)
              return result if condition_result
            else
              return result if result
            end
            tries += 1
            return result if max_tries == tries
            sleep sleep_interval
          rescue RescuableError => e
            tries += 1
            $stderr.puts "ERROR: Error making request - #{e.class} #{e.message} #{e.backtrace.find{|l| l.include?('pact_broker-client')}}, attempt #{tries} of #{max_tries}"
            raise e if max_tries == tries
            sleep sleep_interval
          end
        end
      end

      def self.sleep seconds
        Kernel.sleep seconds
      end
    end
  end
end
