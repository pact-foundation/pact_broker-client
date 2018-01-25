require 'pact_broker/client/base_client'
module PactBroker
  module Client
    describe BaseClient do
      describe '#initialize' do
        subject { BaseClient.new(base_url: base_url) }

        let(:base_url) { 'http://pact_broker_base_url'}
        let(:username) { 'pact_repo_username'}
        let(:password) { 'pact_repo_password'}
        let(:client_options) do
          {
            basic_auth: {
              username: username,
              password: password
            }
          }
        end
        context 'with basic url' do
          it 'should set base url' do
            base_client = BaseClient.new(base_url: base_url)
            expect(base_client.base_url).to eq(base_url)
            expect(BaseClient.base_uri).to eq(base_url)
          end
        end

        context 'with client options' do
          subject { BaseClient.new(base_url: base_url, client_options: client_options) }
          it 'should set client options ' do
            expect(subject.client_options).to eq(client_options)
          end

          it 'should set httpparty basic auth when client options contains basic auth' do
            expect(BaseClient).to receive(:basic_auth).with(username, password)
            subject
          end
        end

        context 'without client options' do
          subject { BaseClient.new(base_url: base_url) }
          it 'should set client options to empty hash ' do
            expect(subject.client_options).to eq({})
          end

          it 'should not set httpparty basic auth' do
            expect(BaseClient).to_not receive(:basic_auth).with(username, password)
            subject
          end
        end

        describe "url_for_relation" do
          let(:index_body) do
            {
              _links: {
                :'pb:foo-bar' => {
                  href: "http://foo-bar/{name}"
                }
              }
            }.to_json
          end

          let!(:request) do
            stub_request(:get, "http://pact_broker_base_url/").to_return(status: 200, body: index_body, headers: { "Content-Type" => "application/json" }  )
          end

          it "retrieves a relation URL from the index" do
            expect(subject.url_for_relation('pb:foo-bar', name: 'wiffle')).to eq 'http://foo-bar/wiffle'
          end

          context "when the relation is not found" do
            it "raises an error" do
              expect { subject.url_for_relation('pb:not-found', name: 'wiffle') }.to raise_error PactBroker::Client::RelationNotFound, /Could not find relation pb:not-found in index resource/
            end
          end
        end
      end
    end
  end
end