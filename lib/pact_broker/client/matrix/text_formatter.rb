require 'table_print'
require 'dig_rb'
require 'pact_broker/client/hash_refinements'

module PactBroker
  module Client
    class Matrix
      class TextFormatter
        using PactBroker::Client::HashRefinements

        Line = Struct.new(:consumer, :consumer_version, :provider, :provider_version, :success, :ref)

        OPTIONS = [
          { consumer: {} },
          { consumer_version: {display_name: 'C.VERSION'} },
          { provider: {} },
          { provider_version: {display_name: 'P.VERSION'} },
          { success: {display_name: 'SUCCESS?'} },
          { ref: { display_name: 'RESULT#' }}
        ]

        def self.call(matrix)
          matrix_rows = matrix[:matrix]
          return "" if matrix_rows.size == 0
          verification_result_number = 0
          data = matrix_rows.each_with_index.collect do | line |
            has_verification_result_url = lookup(line, nil, :verificationResult, :_links, :self, :href)
            if has_verification_result_url
              verification_result_number += 1
            end
            Line.new(
              lookup(line, "???", :consumer, :name),
              lookup(line, "???", :consumer, :version, :number),
              lookup(line, "???", :provider, :name) ,
              lookup(line, "???", :provider, :version, :number),
              (lookup(line, "???", :verificationResult, :success)).to_s,
              has_verification_result_url ? verification_result_number : ""
            )
          end

          printer = TablePrint::Printer.new(data, OPTIONS)
          printer.table_print + verification_result_urls_text(matrix)
        end

        def self.lookup line, default, *keys
          keys.reduce(line) { | line, key | line[key] }
        rescue NoMethodError
          default
        end

        def self.verification_results_urls_and_successes(matrix)
          (matrix[:matrix] || []).collect do | row |
            url = row.dig(:verificationResult, :_links, :self, :href)
            if url
              success = row.dig(:verificationResult, :success)
              [url, success]
            else
              nil
            end
          end.compact
        end

        def self.verification_result_urls_text(matrix)
          text = self.verification_results_urls_and_successes(matrix).each_with_index.collect do |(url, success), i|
            status = success ? 'success' : 'failure'
            "#{i+1}. #{url} (#{status})"
          end.join("\n")

          if text.size > 0
            "\n\nVERIFICATION RESULTS\n--------------------\n#{text}"
          else
            text
          end
        end
      end
    end
  end
end
