
# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pact_broker/client/version'

Gem::Specification.new do |gem|
  gem.name          = "pact_broker-client"
  gem.version       = PactBroker::Client::VERSION
  gem.authors       = ["Bethany Skurrie"]
  gem.email         = ["bskurrie@dius.com.au"]
  gem.description   = %q{Publishes pacts to, and retrieves pacts from, the pact broker server.}
  gem.summary       = %q{See description}
  gem.homepage      = "https://github.com/bethesque/pact_broker-client.git"

  gem.required_ruby_version = '>= 2.0'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.license       = 'MIT'

  gem.add_runtime_dependency 'pact'
  gem.add_runtime_dependency 'httparty'
  gem.add_runtime_dependency 'json'
  gem.add_runtime_dependency 'term-ansicolor'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'fakefs', '~> 0.4'
  gem.add_development_dependency 'rspec-fire'
  gem.add_development_dependency 'appraisal'
end
