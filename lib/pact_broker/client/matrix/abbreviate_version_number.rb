module PactBroker
  module Client
    class Matrix
      class AbbreviateVersionNumber
        def self.call version_number
          if version_number
            version_number.gsub(/[A-Za-z0-9]{40}/) do | val |
              val[0...7] + "..."
            end
          end
        end
      end
    end
  end
end
