module PactBroker
  module Client
    class Matrix
      class AbbreviateVersionNumber
        # Official regex from https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
        SEMVER_REGEX = /(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?/
        SHA1_REGEX = /[A-Za-z0-9]{40}/

        class << self
          def call version_number
            return unless version_number

            return replace_all_git_sha(version_number) if [SEMVER_REGEX, SHA1_REGEX].all?{|r| regex_match?(r, version_number) }

            return replace_all_git_sha(version_number) if regex_match?(Regexp.new("\\A#{SHA1_REGEX.source}\\z"), version_number)

            # Trim to some meaningful value in case we couldn't match anything, just not to mess with the output
            return version_number[0...60] + '...' if version_number.length > 60

            version_number
          end

          private

          # To support ruby2.2
          def regex_match?(regex, value)
            !regex.match(value).nil?
          end

          def replace_all_git_sha(version)
            version.gsub(SHA1_REGEX) { |val| val[0...7] + '...' }
          end
        end
      end
    end
  end
end
