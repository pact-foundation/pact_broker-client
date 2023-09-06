require "pactflow/client/cli/pactflow"

RSpec.describe "publish-provider-contract" do
  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with("PACT_BROKER_FEATURES", "").and_return("publish_provider_contracts_all_in_one")
  end
  let(:index_body_hash) do
    {
      _links: {
        "pf:publish-provider-contract" => {
          href: "http://broker/some-publish/{provider}"
        }
      }
    }
  end

  let(:post_response_body) do
      {
        "notices"=>[{"text"=>"some notice", "type"=>"info"}, {"text"=>"some other notice", "type"=>"info"}]
      }
  end

  let!(:index_request) do
    stub_request(:get, "http://broker").to_return(status: 200, body: index_body_hash.to_json, headers: { "Content-Type" => "application/hal+json" }  )
  end

  let!(:publish_request) do
    stub_request(:post, "http://broker/some-publish/Bar").to_return(status: 200, body: post_response_body.to_json, headers: { "Content-Type" => "application/hal+json" }  )
  end

  let(:parameters) do
    %w{
      publish-provider-contract
      script/oas.yml
      --provider Bar
      --broker-base-url http://broker
      --provider-app-version 1013b5650d61214e19f10558f97fb5a3bb082d44
      --branch main
      --tag dev
      --specification oas
      --content-type application/yml
      --verification-exit-code 0
      --verification-results script/verification-results.txt
      --verification-results-content-type text/plain
      --verification-results-format text
      --verifier my-custom-tool
      --verifier-version "1.0"
    }
  end

  subject { capture(:stdout) { Pactflow::Client::CLI::Pactflow.start(parameters) } }

  it "prints the notices" do
    Approvals.verify(subject, :name => "publish_provider_contract", format: :txt)
  end
end
