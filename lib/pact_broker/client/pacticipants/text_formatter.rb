require 'table_print'
require 'ostruct'

module PactBroker
  module Client
    module Pacticipants2
      class TextFormatter
        def self.call(pacticipants)
          return "" if pacticipants.size == 0

          data = pacticipants.collect do | pacticipant |
            # Might add a UUID in at some stage. Backwards compatible supporting code.
            OpenStruct.new({ uuid: "" }.merge(pacticipant).merge(url: pacticipant["_links"]["self"]["href"]))
          end.sort_by{ | pacticipant | pacticipant.name.downcase }

          TablePrint::Printer.new(data, tp_options(data)).table_print
        end

        def self.tp_options(data)
          uuid_width = max_width(data, :uuid, "")
          name_width = max_width(data, :name, "NAME")
          display_name_width = max_width(data, :displayName, "DISPLAY NAME")

          tp_options = [
            { name: { width: name_width} },
            { displayName: { display_name: "Display name", width: display_name_width } },
          ]

          if uuid_width > 0
            tp_options.unshift({ uuid: { width: uuid_width } })
          end
          tp_options
        end

        def self.max_width(data, column, title)
          (data.collect{ |row| row.send(column) } + [title]).compact.collect(&:size).max
        end
      end
    end
  end
end
