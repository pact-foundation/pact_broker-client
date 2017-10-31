describe "pact-broker create-version-tag" do
  before(:all) do
    @pipe = IO.popen("bundle exec pact-stub-service spec/pacts/pact_broker_client-pact_broker.json -p 5001")
    sleep 2
  end

  context "when the version is successfully tagged" do
    subject { `bundle exec bin/pact-broker create-version-tag -v --pacticipant Condor --version 1.3.0 --tag prod --broker-base-url http://localhost:5001` }

    it "returns a success exit code" do
      subject
      expect($?.exitstatus).to eq 0
      expect(subject).to include 'Tagging Condor version 1.3.0 as prod'
    end
  end

  after(:all) do
    Process.kill 'KILL', @pipe.pid
  end
end
