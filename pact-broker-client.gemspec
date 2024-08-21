
# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pact_broker/client/version'

Gem::Specification.new do |gem|
  gem.name          = "pact_broker-client"
  gem.version       = PactBroker::Client::VERSION
  gem.authors       = ["Beth Skurrie"]
  gem.email         = ["beth@bethesque.com"]
  gem.description   = %q{Client for the Pact Broker. Publish, retrieve and query pacts and verification results. Manage webhooks and environments.}
  gem.summary       = %q{See description}
  gem.homepage      = "https://github.com/pact-foundation/pact_broker-client.git"
  gem.files         = `git ls-files`.split($/).reject { |file| file.match(/(test\/|spec\/|.github\/)/) }

  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]
  gem.license       = 'MIT'

  gem.add_runtime_dependency 'httparty', ">= 0.21.0", "< 1.0.0"
  gem.add_runtime_dependency 'term-ansicolor', '~> 1.7'
  gem.add_runtime_dependency 'table_print', '~> 1.5'
  gem.add_runtime_dependency 'thor', '>= 0.20', '< 2.0'
  gem.add_runtime_dependency 'rake', '~> 13.0' #For FileList
  gem.add_runtime_dependency 'dig_rb', '~> 1.0'
  gem.add_runtime_dependency 'base64', '~> 0.2'
end
