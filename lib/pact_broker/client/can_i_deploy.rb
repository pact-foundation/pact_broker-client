require 'pact_broker/client/error'
require 'pact_broker/client/pact_broker_client'
require 'pact_broker/client/retry'
require 'pact_broker/client/matrix/formatter'
require 'term/ansicolor'
require 'pact_broker/client/colorize_notices'

module PactBroker
  module Client
    class CanIDeploy

      class Result
        attr_reader :success, :message

        def initialize success, message = nil
          @success = success
          @message = message
        end
      end

      def self.call(pact_broker_base_url, version_selectors, matrix_options, options, pact_broker_client_options={})
        new(pact_broker_base_url, version_selectors, matrix_options, options, pact_broker_client_options).call
      end

      def initialize(pact_broker_base_url, version_selectors, matrix_options, options, pact_broker_client_options)
        @pact_broker_base_url = pact_broker_base_url
        @version_selectors = version_selectors
        @matrix_options = matrix_options
        @options = options
        @pact_broker_client_options = pact_broker_client_options
      end

      def call
        create_result(fetch_matrix_with_retries)
      rescue PactBroker::Client::Error => e
        Result.new(dry_run_or_false, for_dry_run(Term::ANSIColor.red(e.message)))
      rescue StandardError => e
        Result.new(dry_run_or_false, for_dry_run(Term::ANSIColor.red("Error retrieving matrix. #{e.class} - #{e.message}") + "\n#{e.backtrace.join("\n")}"))
      end

      private

      attr_reader :pact_broker_base_url, :version_selectors, :matrix_options, :options, :pact_broker_client_options

      def create_result(matrix)
        if matrix.deployable?
          Result.new(true, success_message(matrix))
        else
          Result.new(dry_run_or_false, failure_message(matrix))
        end
      end

      def success_message(matrix)
        message = format_matrix(matrix)
        if format != 'json'
          message = warning(matrix) + computer_says(true) + message + "\n\n" + notice_or_reason(matrix, :green)
          message = for_dry_run(message)
        end
        message
      end

      def failure_message(matrix)
        message = format_matrix(matrix)
        if format != 'json'
          message = warning(matrix) + computer_says(false) + message + "\n\n" + notice_or_reason(matrix, :red)
          message = for_dry_run(message)
        end
        message
      end

      def computer_says(success)
        if success
          if dry_run?
            "Computer says yes \\o/ (and maybe you don't need to enable dry run)"
          else
            Term::ANSIColor.green('Computer says yes \o/ ')
          end
        else
          if dry_run?
            "Computer says no ¯\\_(ツ)_/¯ (but you're ignoring this by enabling dry run)"
          else
            Term::ANSIColor.red("Computer says no ¯\_(ツ)_/¯")
          end
        end
      end

      def notice_or_reason(matrix, reason_color)
        if matrix.notices
          PactBroker::Client::ColorizeNotices.call(matrix.notices).join("\n")
        else
          Term::ANSIColor.send(reason_color, matrix.reason)
        end
      end

      def format_matrix(matrix)
        formatted_matrix = Matrix::Formatter.call(matrix, format)
        if format != 'json' && formatted_matrix.size > 0
          "\n\n" + formatted_matrix
        else
          formatted_matrix
        end
      end

      def format
        options[:output]
      end

      def fetch_matrix
        Retry.while_error { pact_broker_client.matrix.get(version_selectors, matrix_options) }
      end

      def fetch_matrix_with_retries
        matrix = fetch_matrix
        if retry_while_unknown?
          check_if_retry_while_unknown_supported(matrix)
          if matrix.any_unknown?
            results = matrix.unknown_count == 1 ? "result" : "results"
            $stderr.puts "Waiting for #{matrix.unknown_count} verification #{results} to be published (maximum of #{wait_time} seconds)"
            matrix = Retry.until_truthy_or_max_times(retry_options) do
              fetch_matrix
            end
          end
        end
        matrix
      end

      def pact_broker_client
        @pact_broker_client ||= PactBroker::Client::PactBrokerClient.new(base_url: pact_broker_base_url, client_options: pact_broker_client_options)
      end

      def retry_while_unknown?
        options[:retry_while_unknown] > 0
      end

      def dry_run?
        options[:dry_run]
      end

      def dry_run_or_false
        dry_run? || false
      end

      def for_dry_run(lines)
        if dry_run?
          prefix = Term::ANSIColor.yellow("[dry-run] ")
          lines.split("\n").collect { |line| prefix + Term::ANSIColor.uncolor(line) }.join("\n") + "\n" + prefix + "\n" + prefix + Term::ANSIColor.green("Dry run enabled - ignoring any failures")
        else
          lines
        end
      end

      def retry_options
        {
          condition: lambda { |matrix| !matrix.any_unknown?  },
          times: retry_tries,
          sleep: retry_interval,
          sleep_first: true
        }
      end

      def retry_interval
        options[:retry_interval]
      end

      def retry_tries
        options[:retry_while_unknown]
      end

      def wait_time
        retry_interval * retry_tries
      end

      def check_if_retry_while_unknown_supported(matrix)
        if !matrix.supports_unknown_count?
          raise PactBroker::Client::Error.new("This version of the Pact Broker does not provide a count of the unknown verification results. Please upgrade your Broker to >= v2.23.4")
        end
      end

      def warning(matrix)
        if matrix_options[:ignore_selectors] && matrix_options[:ignore_selectors].any? && !matrix.supports_ignore?
          Term::ANSIColor.yellow("WARN: This version of the Pact Broker does not support ignoring pacticipants. Please upgrade your Broker to >= 2.80.0") + "\n\n"
        else
          ""
        end
      end
    end
  end
end
