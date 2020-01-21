require 'pact_broker/client/cli/version_selector_options_parser'

module PactBroker
  module Client
    module CLI
      describe VersionSelectorOptionsParser do

        TEST_CASES = [
          [
            ["--pacticipant", "Foo", "--version", "1.2.3"],
            [{ pacticipant: "Foo", version: "1.2.3" } ]
          ],[
            ["-a", "Foo", "-e", "1.2.3"],
            [{ pacticipant: "Foo", version: "1.2.3" } ]
          ],[
            ["--pacticipant", "Foo"],
            [{ pacticipant: "Foo" } ]
          ],[
            ["--pacticipant", "Foo", "Bar"],
            [{ pacticipant: "Bar" } ]
          ],[
            ["--pacticipant", "Foo", "--pacticipant", "Bar", "--version", "1.2.3"],
            [{ pacticipant: "Foo" }, { pacticipant: "Bar", version: "1.2.3" } ]
          ],[
            ["--pacticipant", "Foo", "--wrong", "Bar", "--version", "1.2.3"],
            [{ pacticipant: "Foo", version: "1.2.3" } ]
          ],[
            ["--pacticipant", "the-thing", "--version", "1.2.3"],
            [{ pacticipant: "the-thing", version: "1.2.3" } ]
          ],[
            ["--version", "1.2.3"],
            [{ pacticipant: nil, version: "1.2.3" } ]
          ],[
            ["--pacticipant", "Foo", "--latest", "--pacticipant", "Bar"],
            [{ pacticipant: "Foo", latest: true }, { pacticipant: "Bar" } ]
          ],[
            ["--pacticipant", "Foo", "--latest", "prod", "--pacticipant", "Bar"],
            [{ pacticipant: "Foo", latest: true, tag: "prod"}, { pacticipant: "Bar" } ]
          ],[
            ["--pacticipant", "Foo", "--all", "prod", "--pacticipant", "Bar"],
            [{ pacticipant: "Foo", tag: "prod"}, { pacticipant: "Bar" } ]
          ],[
            ["--pacticipant=Foo", "--version=1.2.3"],
            [{ pacticipant: "Foo", version: "1.2.3" } ]
          ],[
            ["--pacticipant=Foo=Bar", "--version", "1.2.3"],
            [{ pacticipant: "Foo=Bar", version: "1.2.3" } ]
          ],[
            ["--pacticipant", "Foo=Bar", "--version", "1.2.3"],
            [{ pacticipant: "Foo=Bar", version: "1.2.3" } ]
          ]
        ]

        TEST_CASES.each do | input, output |

          it "parses #{input.join(' ')}" do
            expect(VersionSelectorOptionsParser.call(input)).to eq output
          end

        end
      end
    end
  end
end