require 'table_print'
require 'ostruct'

module PactBroker
  module Client
    module Environments
      class TextFormatter

        def self.call(environments)
          return "" if environments.size == 0

          data = environments.collect do | environment |
            OpenStruct.new(environment)
          end.sort_by{ | environment | environment.name.downcase }

          uuid_width = data.collect(&:uuid).collect(&:size).max

          tp_options = [
            { uuid: { width: uuid_width } },
            { name: {} },
            { displayName: { display_name: "Display name" } },
            { production: {} }
          ]

          TablePrint::Printer.new(data, tp_options).table_print
        end
      end
    end
  end
end
