require 'bundler/gem_helper'
module Bundler
  class GemHelper
    def install
      desc "Build #{name}-#{version}.gem into the pkg directory"
      task 'build' do
        build_gem
      end

      desc "Build and install #{name}-#{version}.gem into system gems"
      task 'install' do
        install_gem
      end

      GemHelper.instance = self
    end
  end
end
Bundler::GemHelper.install_tasks
require 'rspec/core/rake_task'
#require 'geminabox-client'

Dir.glob('lib/tasks/**/*.rake').each { |task| load "#{Dir.pwd}/#{task}" }
Dir.glob('tasks/**/*.rake').each { |task| load "#{Dir.pwd}/#{task}" }
RSpec::Core::RakeTask.new(:spec)

task :default => [:spec]

# desc "Release to REA gems host"
# task :publish => :build do
#   gem_file = "pkg/pact-broker-client#{PactBroker::Client::VERSION}.gem"
#   Geminabox::Client.new('http://rea-rubygems').upload(gem_file)
# end
