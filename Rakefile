require "bundler/gem_tasks"
require 'rspec/core/rake_task'

Dir.glob('lib/tasks/**/*.rake').each { |task| load "#{Dir.pwd}/#{task}" }
Dir.glob('tasks/**/*.rake').each { |task| load "#{Dir.pwd}/#{task}" }
RSpec::Core::RakeTask.new(:spec)

task :default => [:spec]
