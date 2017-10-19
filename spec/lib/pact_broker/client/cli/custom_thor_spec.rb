require 'pact_broker/client/cli/custom_thor'

module PactBroker::Client::CLI

  class Delegate
    def self.call options; end
  end

  class TestThor < CustomThor
    desc 'ARGUMENT', 'This is the description'
    def test_default(argument)
      Delegate.call(argument: argument)
    end

    desc '', ''
    method_option :multi, type: :array
    def test_multiple_options
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
