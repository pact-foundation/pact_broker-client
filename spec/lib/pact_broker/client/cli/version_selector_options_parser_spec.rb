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
          ],[
            ["--ignore", "Foo", "--version", "1.2.3"],
            [{ pacticipant: "Foo", version: "1.2.3", ignore: true }]
          ],[
            ["--ignore", "Foo", "--ignore", "Bar", "--version", "1.2.3"],
            [{ pacticipant: "Foo", ignore: true }, { pacticipant: "Bar", version: "1.2.3", ignore: true }]
          ],[
            ["--ignore", "Foo", "--pacticipant", "Bar", "--version", "1.2.3"],
            [{ pacticipant: "Foo", ignore: true }, { pacticipant: "Bar", version: "1.2.3" }]
          ],[
            ["--pacticipant", "Foo", "--version", "1", "--version", "2"],
            [{ pacticipant: "Foo", version: "2" }]
          ],[
            ["--pacticipant", "Foo", "--version", "2", "--latest"],
            [{ pacticipant: "Foo", version: "2", latest: true }]
          ],[
            ["--pacticipant", "Foo", "--version", "2", "--latest", "--latest"],
            [{ pacticipant: "Foo", version: "2", latest: true }]
          ],[
            ["--version", "2"],
            [{ pacticipant: nil, version: "2" }]
          ],[
            ["--pacticipant", "Foo", "--branch", "main"],
            [{ pacticipant: "Foo", branch: "main", latest: true }]
          ],[
            ["--branch", "main"],
            [{ pacticipant: nil, branch: "main", latest: true }]
          ],[
            ["--pacticipant", "Foo", "--main-branch", "--pacticipant", "Bar", "--version", "1"],
            [{ pacticipant: "Foo", main_branch: true, latest: true }, { pacticipant: "Bar", version: "1" }]
          ],[
            ["--main-branch"],
            [{ pacticipant: nil, main_branch: true, latest: true }]
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