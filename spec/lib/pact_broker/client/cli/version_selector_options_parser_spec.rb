require 'pact_broker/client/cli/version_selector_options_parser'

module PactBroker
  module Client
    module CLI
      describe VersionSelectorOptionsParser do

        TEST_CASES = [
          [
            ["--name", "Foo", "--version", "1.2.3"],
            [{ name: "Foo", version: "1.2.3" } ]
          ],[
            ["-n", "Foo", "-a", "1.2.3"],
            [{ name: "Foo", version: "1.2.3" } ]
          ],[
            ["--name", "Foo"],
            [{ name: "Foo" } ]
          ],[
            ["--name", "Foo", "Bar"],
            [{ name: "Bar" } ]
          ],[
            ["--name", "Foo", "--name", "Bar", "--version", "1.2.3"],
            [{ name: "Foo" }, { name: "Bar", version: "1.2.3" } ]
          ],[
            ["--name", "Foo", "--wrong", "Bar", "--version", "1.2.3"],
            [{ name: "Foo", version: "1.2.3" } ]
          ],[
            ["--name", "the-thing", "--version", "1.2.3"],
            [{ name: "the-thing", version: "1.2.3" } ]
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