module PactBroker
  module Client
    module CLI
      class VersionSelectorOptionsParser
        def self.call options
          versions = []
          last_flag = nil
          options.each do | option |
            case option
            when "--pacticipant", "-a"
              versions << {}
            when /^\-/
              nil
            else
              case last_flag
              when "--pacticipant", "-a"
                versions.last[:pacticipant] = option
              when "--version", "-e"
                versions << {pacticipant: nil} unless versions.last
                versions.last[:version] = option
              end
            end
            last_flag = option if option.start_with?("-")
          end
          versions
        end
      end
    end
  end
end