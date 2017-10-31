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
            when "--latest", "-l"
              versions << {pacticipant: nil} unless versions.last
              versions.last[:latest] = true
            when /^\-/
              nil
            else
              case last_flag
              when "--pacticipant", "-a"
                versions.last[:pacticipant] = option
              when "--version", "-e"
                versions << {pacticipant: nil} unless versions.last
                versions.last[:version] = option
              when "--latest", "-l"
                versions << {pacticipant: nil} unless versions.last
                versions.last[:tag] = option
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