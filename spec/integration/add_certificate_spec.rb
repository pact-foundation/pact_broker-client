describe "pact-broker add-certificate", skip_windows: true do
  before(:all) do
    @pipe = IO.popen("bundle exec pact-stub-service spec/pacts/pact_broker_client-pact_broker.json -p 5001")
    sleep 2
  end

  context "when the certificate is successfully added" do
    subject { `bundle exec bin/pact-broker add-certificate spec/support/cacert.pem --description "The Jenkins cert"` }

    it "returns a success exit code" do
      subject
      expect($?.exitstatus).to eq 0
      expect(subject).to include 'Certificate added'
    end
  end

  after(:all) do
    Process.kill 'KILL', @pipe.pid
  end
end
