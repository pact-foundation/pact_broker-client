module PactBroker
  module Client
    module CLI
      class VersionSelectorOptionsParser
        def self.call words
          selectors = []
          previous_option = nil
          words.each do | word |
            case word
            when "--pacticipant", "-a"
              selectors << {}
            when "--latest", "-l"
              selectors << { pacticipant: nil } if selectors.empty?
              selectors.last[:latest] = true
            when /^\-/
              nil
            else
              case previous_option
              when "--pacticipant", "-a"
                selectors.last[:pacticipant] = word
              when "--version", "-e"
                selectors << { pacticipant: nil } if selectors.empty?
                selectors.last[:version] = word
              when "--latest", "-l"
                selectors << { pacticipant: nil } if selectors.empty?
                selectors.last[:tag] = word
              when "--all"
                selectors << { pacticipant: nil } if selectors.empty?
                selectors.last[:tag] = word
              end
            end
            previous_option = word if word.start_with?("-")
          end
          selectors
        end
      end
    end
  end
end