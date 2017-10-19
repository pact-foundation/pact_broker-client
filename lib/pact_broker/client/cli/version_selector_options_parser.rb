module PactBroker
  module Client
    module CLI
      class VersionSelectorOptionsParser
        def self.call options
          versions = []
          last_flag = nil
          options.each do | option |
            case option
            when "--name", "-n"
              versions << {}
            when /^\-/
              nil
            else
              case last_flag
              when "--name", "-n"
                versions.last[:name] = option
              when "--version", "-a"
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