require 'pact_broker/client/cli/custom_thor'

module PactBroker::Client::CLI

  class Delegate
    def self.call options; end
  end

  class TestThor < CustomThor
    def self.exit_on_failure?
      false
    end

    desc 'ARGUMENT', 'This is the description'
    def test_default(argument)
      Delegate.call(argument: argument)
    end

    desc '', ''
    method_option :multi, type: :array
    def test_multiple_options
      Delegate.call(options)
    end

    desc '', ''
    method_option :broker_base_url, required: true, aliases: "-b"
    method_option :broker_username, aliases: "-u"
    method_option :broker_password, aliases: "-p"
    method_option :broker_token, aliases: "-k"
    def test_using_env_vars
      Delegate.call(options)
    end

    desc '', ''
    method_option :broker_base_url, required: true, aliases: "-b"
    method_option :broker_username, aliases: "-u"
    method_option :broker_password, aliases: "-p"
    method_option :broker_token, aliases: "-k"
    def test_pact_broker_client_options
      Delegate.call(pact_broker_client_options)
    end

    desc '', ''
    ignored_and_hidden_potential_options_from_environment_variables
    def test_without_parameters
      Delegate.call(options)
    end

    default_command :test_default
  end

  describe CustomThor do
    subject { TestThor.new }

    it "converts options that are specified multiple times into a single array" do
      expect(Delegate).to receive(:call).with({'multi' => ['one', 'two']})
      TestThor.start(%w{test_multiple_options --multi one --multi two})
    end

    context "with broker configuration in the environment variables" do
      before do
        ENV['PACT_BROKER_BASE_URL'] = 'http://foo'
        ENV['PACT_BROKER_USERNAME'] = 'username'
        ENV['PACT_BROKER_PASSWORD'] = 'password'
        ENV['PACT_BROKER_TOKEN'] = 'token'
      end

      it "populates the base URL from the environment variables" do
        expect(Delegate).to receive(:call) do | options |
          expect(options.broker_base_url).to eq 'http://foo'
        end
        TestThor.start(%w{test_using_env_vars})
      end

      it "does not override a value specifed on the command line" do
        expect(Delegate).to receive(:call) do | options |
          expect(options.broker_base_url).to eq 'http://bar'
        end
        TestThor.start(%w{test_using_env_vars --broker-base-url http://bar})
      end

      it "allows commands to be called that don't use the environment variables" do
        expect(Delegate).to receive(:call)
        TestThor.start(%w{test_without_parameters})
      end
    end

    it "removes trailing slashes from the broker base url when passed as an arg" do
      expect(Delegate).to receive(:call) do | options |
        expect(options[:pact_broker_base_url]).to eq 'http://bar'
      end
      TestThor.start(%w{test_pact_broker_client_options --broker-base-url http://bar/})
    end

    it "removes trailing slashes from the broker base url when passed as an env var" do
      ENV['PACT_BROKER_BASE_URL'] = 'http://bar/'
      expect(Delegate).to receive(:call) do | options |
        expect(options[:pact_broker_base_url]).to eq 'http://bar'
      end
      TestThor.start(%w{test_pact_broker_client_options})
    end

    describe ".handle_help" do
      context "when the last argument is --help or -h" do
        it "turns it into the form that Thor expects, which is a really odd one" do
          expect(TestThor.handle_help(["foo", "--help"])).to eq ["help", "foo"]
          expect(TestThor.handle_help(["foo", "-h"])).to eq ["help", "foo"]
          expect(TestThor.handle_help(["-h"])).to eq ["help"]
          expect(TestThor.handle_help(["--help"])).to eq ["help"]
        end
      end
    end

    describe ".turn_muliple_tag_options_into_array" do
      it "turns '--tag foo --tag bar' into '--tag foo bar'" do
        input = %w{--ignore this --tag foo --tag bar --wiffle --that}
        output = %w{--ignore this --tag foo bar --wiffle --that }
        expect(TestThor.turn_muliple_tag_options_into_array(input)).to eq output
      end

      it "turns '--tag foo bar --tag meep' into '--tag foo meep bar'" do
        input = %w{--ignore this --tag foo bar --tag meep --wiffle --that}
        output = %w{--ignore this --tag foo meep bar --wiffle --that}
        expect(TestThor.turn_muliple_tag_options_into_array(input)).to eq output
      end

      it "turns '--tag foo --tag bar wiffle' into '--tag foo bar wiffle' which is silly" do
        input = %w{--ignore this --tag foo --tag bar wiffle}
        output = %w{--ignore this --tag foo bar wiffle}
        expect(TestThor.turn_muliple_tag_options_into_array(input)).to eq output
      end

      it "maintains '--tag foo bar wiffle'" do
        input = %w{--ignore this --tag foo bar wiffle --meep}
        output = %w{--ignore this --tag foo bar wiffle --meep}
        expect(TestThor.turn_muliple_tag_options_into_array(input)).to eq output
      end

      it "turns '-t foo -t bar' into '-t foo bar'" do
        input = %w{--ignore this -t foo -t bar --meep --that 1 2 3}
        output = %w{--ignore this -t foo bar --meep --that 1 2 3}
        expect(TestThor.turn_muliple_tag_options_into_array(input)).to eq output
      end

      it "turns '--tag=foo --tag=bar' into '--tag foo bar'" do
        input = %w{--ignore this --tag=foo --tag=bar --wiffle --that}
        output = %w{--ignore this --tag foo bar --wiffle --that }
        expect(TestThor.turn_muliple_tag_options_into_array(input)).to eq output
      end

      it "doesn't change anything when there are no duplicate options" do
        input = %w{--ignore this --taggy foo --blah bar --wiffle --that}
        expect(TestThor.turn_muliple_tag_options_into_array(input)).to eq input
      end

      it "return an empty array when given an empty array" do
        input = []
        expect(TestThor.turn_muliple_tag_options_into_array(input)).to eq input
      end
    end
  end
end
