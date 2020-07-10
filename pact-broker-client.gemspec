
# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pact_broker/client/version'

Gem::Specification.new do |gem|
  gem.name          = "pact_broker-client"
  gem.version       = PactBroker::Client::VERSION
  gem.authors       = ["Beth Skurrie"]
  gem.email         = ["bskurrie@dius.com.au"]
  gem.description   = %q{Client for the Pact Broker. Publish, retrieve and query pacts and verification results.}
  gem.summary       = %q{See description}
  gem.homepage      = "https://github.com/bethesque/pact_broker-client.git"

  gem.required_ruby_version = '>= 2.0'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.license       = 'MIT'

  gem.add_runtime_dependency 'httparty', '~>0.18'
  gem.add_runtime_dependency 'term-ansicolor', '~> 1.7'
  gem.add_runtime_dependency 'table_print', '~> 1.5'
  gem.add_runtime_dependency 'thor', '~> 0.20'
  gem.add_runtime_dependency 'rake', '~> 13.0' #For FileList

  gem.add_development_dependency 'fakefs', '~> 0.4'
  gem.add_development_dependency 'webmock', '~> 3.0'
  gem.add_development_dependency 'conventional-changelog', '~>1.3'
  gem.add_development_dependency 'pact', '~> 1.16'
end
