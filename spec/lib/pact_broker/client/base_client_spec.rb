require 'pact_broker/client/base_client'
module PactBroker
  module Client
    describe BaseClient do
      subject { BaseClient.new(base_url: base_url) }

      let(:base_url) { 'http://pact_broker_base_url'}

      describe '#initialize' do
        let(:username) { 'pact_repo_username'}
        let(:password) { 'pact_repo_password'}
        let(:token) { '123456789' }
        let(:client_options) do
          {
            basic_auth: {
              username: username,
              password: password
            },
            token: token
          }
        end

        context 'with basic url' do
          it 'sets the base url' do
            base_client = BaseClient.new(base_url: base_url)
            expect(base_client.base_url).to eq(base_url)
            expect(BaseClient.base_uri).to eq(base_url)
          end
        end

        context 'with client options' do
          subject { BaseClient.new(base_url: base_url, client_options: client_options) }
          it 'sets the client options' do
            expect(subject.client_options).to eq(client_options)
          end

          context 'when client options contains basic auth' do
            it 'sets the httpparty basic auth' do
              expect(BaseClient).to receive(:basic_auth).with(username, password)
              subject
            end
          end

          context  'when client options contains broker token' do
            it 'sets the httparty broker token' do
              expect(BaseClient).to receive(:headers).with('Authorization' => "Bearer #{token}")
              subject
            end
          end
        end

        context 'without client options' do
          subject { BaseClient.new(base_url: base_url) }
          it 'set the client options to empty hash ' do
            expect(subject.client_options).to eq({})
          end

          it 'does not set the httpparty basic auth' do
            expect(BaseClient).to_not receive(:basic_auth).with(username, password)
            subject
          end

          it 'does not set the httparty broker token' do
            expect(BaseClient).to_not receive(:headers).with('Authorization' => "Bearer #{token}")
            subject
          end
        end

        context 'when the SSL_CERT_FILE environment variable is set' do
          before do
            allow(ENV).to receive(:[]).and_call_original
            allow(ENV).to receive(:[]).with('SSL_CERT_FILE').and_return('ssl_cert_file')
          end

          subject { BaseClient.new(base_url: base_url) }

          it 'sets the ssl_ca_file' do
            expect(BaseClient).to receive(:ssl_ca_file).with('ssl_cert_file')
            subject
          end
        end

        context 'when the SSL_CERT_DIR environment variable is set' do
          before do
            allow(ENV).to receive(:[]).and_call_original
            allow(ENV).to receive(:[]).with('SSL_CERT_DIR').and_return('ssl_cert_dir')
          end

          subject { BaseClient.new(base_url: base_url) }

          it 'sets the ssl_ca_file' do
            expect(BaseClient).to receive(:ssl_ca_path).with('ssl_cert_dir')
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

      describe '#handle_response' do
        let(:response) { double('Response', success?: true) }

        it 'yields response object' do
          expect { |block| subject.handle_response(response, &block) }.to yield_with_args(response)
        end

        context 'with 404 response' do
          let(:response) { double('Response', success?: false, code: 404) }
          it 'returns nil' do
            expect(subject.handle_response(response)).to be_nil
          end
        end

        context 'with 401 response' do
          let(:response) { double('Response', success?: false, code: 401, body: 'body') }
          it 'raise an exception with meaningful message' do
            expect { subject.handle_response(response) }
              .to raise_error(PactBroker::Client::Error, "Authentication failed: body")
          end
        end

        context 'with 403 response' do
          let(:response) { double('Response', success?: false, code: 403, body: 'body') }
          it 'raise an exception with meaningful message' do
            expect { subject.handle_response(response) }
              .to raise_error(PactBroker::Client::Error, "Authorization failed (insufficient permissions): body")
          end
        end

        context 'with 409 response' do
          let(:response) { double('Response', success?: false, code: 409, body: 'body') }
          it 'raise an exception with meaningful message' do
            expect { subject.handle_response(response) }
              .to raise_error(PactBroker::Client::Error, "Potential duplicate pacticipants: body")
          end
        end

        context 'with unsuccessful JSON response' do
          let(:response) do
            double('Response', success?: false, code: 500, body: '{"errors": ["Internal server error"]}')
          end
          it 'raise an exception with meaningful message' do
            expect { subject.handle_response(response) }
              .to raise_error(PactBroker::Client::Error, "Internal server error")
          end
        end

        context 'with unsucessful nono-JSON response ' do
          let(:response) { double('Response', success?: false, code: 500, body: 'Internal server error') }
          it 'raise an exception with meaningful message' do
            expect { subject.handle_response(response) }
              .to raise_error(PactBroker::Client::Error, "status=500 Internal server error")
          end
        end
      end
    end
  end
end
