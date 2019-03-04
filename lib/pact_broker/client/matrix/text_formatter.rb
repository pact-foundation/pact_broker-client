require 'table_print'

module PactBroker
  module Client
    class Matrix
      class TextFormatter

        Line = Struct.new(:consumer, :consumer_version, :provider, :provider_version, :success)

        OPTIONS = [
          { consumer: {} },
          { consumer_version: {display_name: 'C.VERSION'} },
          { provider: {} },
          { provider_version: {display_name: 'P.VERSION'} },
          { success: {display_name: 'SUCCESS?'} }
        ]

        def self.call(matrix)
          matrix_rows = matrix[:matrix]
          return "" if matrix_rows.size == 0
          data = matrix_rows.collect do | line |
            Line.new(
              lookup(line, :consumer, :name),
              lookup(line, :consumer, :version, :number),
              lookup(line, :provider, :name),
              lookup(line, :provider, :version, :number),
              lookup(line, :verificationResult, :success).to_s
            )
          end

          printer = TablePrint::Printer.new(data, OPTIONS)
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
end
