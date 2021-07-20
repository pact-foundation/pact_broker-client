require "pact_broker/client/can_i_deploy"

module PactBroker
  module Client
    class VerificationRequired < PactBroker::Client::CanIDeploy
      def call
        create_result(fetch_matrix_with_retries)
      rescue StandardError => e
        message = "Error determining if a verification already existed (#{e.message}) - verification should run just in case"
        if options[:verbose]
          message = "#{message}\n#{e.class} - #{e.backtrace.join("\n")}"
        end
        Result.new(true, message)
      end

      private

      def create_result(matrix)
        matrix_and_notices = format_matrix(matrix) + "\n\n" + remove_warnings(Term::ANSIColor.uncolor(notice_or_reason(matrix, :white)))
        # If the specified version numbers do not exist, then all the counts come back 0. Can't just check for unknown to be 0.
        # This command needs to handle "I screwed up the query"
        if matrix.no_results?
          Result.new(true, matrix_and_notices + "\n\nVerification is required.")
        else
          Result.new(false, matrix_and_notices + "\n\nNo verification is required.")
        end
      end

      def remove_warnings(lines)
        lines.split("\n").select{ | line | !line.include?("WARN:") }.join("\n")
      end
    end
  end
end
