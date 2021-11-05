# frozen_string_literal: true

module PactBroker
  module Client
    module CLI
      class VersionSelectorOptionsParser

        def self.call words
          selectors = []
          previous_option = nil
          split_equals(words).each do | word |
            case word
            when "--pacticipant", "-a"
              selectors << {}
            when "--ignore"
              selectors << { ignore: true }
            when "--latest", "-l"
              selectors << { pacticipant: nil } if selectors.empty?
              selectors.last[:latest] = true
            when /^\-/
              nil
            else
              case previous_option
              when "--pacticipant", "-a"
                selectors.last[:pacticipant] = word
              when "--ignore"
                selectors.last[:pacticipant] = word
              when "--version", "-e"
                selectors << { pacticipant: nil } if selectors.empty?
                selectors.last[:version] = word
              when "--latest", "-l"
                selectors << { pacticipant: nil } if selectors.empty?
                selectors.last[:tag] = word
              when "--branch"
                selectors << { pacticipant: nil } if selectors.empty?
                selectors.last[:branch] = word
                selectors.last[:latest] = true
              when "--all"
                selectors << { pacticipant: nil } if selectors.empty?
                selectors.last[:tag] = word
              end
            end
            previous_option = word if word.start_with?("-")
          end
          selectors
        end

        def self.split_equals(words)
          words.flat_map do |word|
            if word.start_with?("-") && word.include?("=")
              word.split('=', 2)
            else
              word
            end
          end
        end
      end
    end
  end
end