# Need Versions class to extend BaseClient until we can remove the old Versions code
require 'pact_broker/client/base_client'
require 'table_print'

module PactBroker
  module Client
    class Versions < BaseClient
      class TextFormatter

        Line = Struct.new(:number, :tags)

        OPTIONS = [
          { number: {:width => 40} },
          { tags: {} }
        ]

        def self.call(version_hash)
          tags = (lookup(version_hash, [], :_embedded, :tags) || []).collect{ | t| t[:name] }.join(" ")
          data = Line.new(version_hash[:number], tags)

          printer = TablePrint::Printer.new([data], OPTIONS)
          printer.table_print
        end

        def self.lookup line, default, *keys
          keys.reduce(line) { | line, key | line[key] }
        rescue NoMethodError
          default
        end
      end
    end
  end
end
