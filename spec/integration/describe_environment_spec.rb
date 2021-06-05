require 'pact_broker/client/cli/broker'

RSpec.describe "describe-environment" do
  let(:index_body_hash) do
    {
      _links: {
        "pb:pacticipant" => {
          href: "http://broker/pacticipants/{pacticipant}"
        }
      }
    }
  end

  let(:pacticipant_body_hash) { JSON.parse(File.read("./spec/support/pacticipant_get.json")) }

  let!(:index_request) do
    stub_request(:get, "http://broker").to_return(status: 200, body: index_body_hash.to_json, headers: { "Content-Type" => "application/hal+json" }  )
  end

  let!(:pacticipant_request) do
    stub_request(:get, "http://broker/pacticipants/Foo").to_return(status: 200, body: pacticipant_body_hash.to_json, headers: { "Content-Type" => "application/hal+json" }  )
  end

  let(:parameters) { %w{describe-pacticipant --name Foo --broker-base-url http://broker} }

  subject { capture(:stdout) { PactBroker::Client::CLI::Broker.start(parameters) } }

  it "prints the pacticipant properties" do
    Approvals.verify(subject, :name => "describe_pacticipant", format: :txt)
  end
end
