source 'https://rubygems.org'

gemspec

# Not sure why jruby on Travis fails saying rake is not part of the bundle,
# even thought it's in the development dependencies. Trying it here.
gem 'rake', '~> 13.0'

if ENV['X_PACT_DEVELOPMENT'] == 'true'
  gem 'pact-mock_service', path: '../pact-mock_service'
  gem 'pact-support', path: '../pact-support'
end

group :development do
  gem 'fakefs', '~> 2.4'
  gem 'webmock', '~> 3.0'
  gem 'conventional-changelog', '~>1.3'
  gem 'pact', '~> 1.16'
  gem 'pact-support', '~> 1.16'
  gem 'approvals', '0.0.26'
  gem 'rspec-its', '~> 1.3'
  gem 'pry-byebug'
end

group :test do
  gem 'faraday', '~>2.0'
  gem 'faraday-retry', '~>2.0'
  gem 'rackup', '~> 2.1'
end
