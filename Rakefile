require "bundler/gem_tasks"

# When running the release action, we don't want to load all the 'prod' gems
# because they're not installed on the release Docker image

require 'rspec/core/rake_task'
require 'conventional_changelog'

Dir.glob('lib/tasks/**/*.rake').each { |task| load "#{Dir.pwd}/#{task}" }
Dir.glob('tasks/**/*.rake').each { |task| load "#{Dir.pwd}/#{task}" }
RSpec::Core::RakeTask.new(:spec) do | task |
  task.rspec_opts = "--pattern spec/lib/**/*_spec.rb"
end

RSpec::Core::RakeTask.new('spec:providers') do | task |
  task.rspec_opts = "--pattern spec/service_providers/**/*_spec.rb"
end

# Must be run after spec:providers because it relies on the generated pact
RSpec::Core::RakeTask.new('spec:integration') do | task |
  task.rspec_opts = "--pattern spec/integration/**/*_spec.rb"
end

task :default => [:spec, 'spec:providers', 'spec:integration']

task :generate_changelog do
  require 'pact_broker/client/version'
  ConventionalChangelog::Generator.new.generate! version: "v#{PactBroker::Client::VERSION}"
end

desc 'List provider states'
task 'pact:list_provider_states' do
  require 'json'
  require 'pact_broker/client/backports'

  puts Dir.glob("spec/pacts/**.json").collect { | pact_file |
    puts pact_file
    JSON.parse(File.read(pact_file))['interactions'].collect{ | interaction| interaction['providerState'] }
  }.flatten.compact.sort.uniq
end
