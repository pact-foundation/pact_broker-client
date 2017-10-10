require 'table_print'

module PactBroker
  module Client
    class MatrixTextFormatter
      Line = Struct.new(:consumer, :consumer_version, :pact_publication_date, :provider, :provider_version, :verification_date)

      def self.call(matrix_lines)
        data = matrix_lines.collect do | line |
          Line.new(
            lookup(line, :consumer, :name),
            lookup(line, :consumer, :version, :number),
            lookup(line, :pact, :createdAt),
            lookup(line, :consumer, :name),
            lookup(line, :provider, :version, :number),
            lookup(line, :verificationResult, :verifiedAt),
          )
        end

        printer = TablePrint::Printer.new(data)
        printer.table_print
      end

      def self.lookup line, *keys
        keys.reduce(line) { | line, key | line[key] }
      rescue NoMethodError
        "???"
      end
    end
  end
end
