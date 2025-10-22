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
  gem 'fakefs', '~> 3.0'
  gem 'webmock', '~> 3.0'
  gem 'conventional-changelog', '~>1.3'
  gem 'pact-support', '~> 1.16'
  gem 'approvals', '0.1.7'
  gem 'rspec-its', '~> 2.0'
  gem 'pry-byebug'

  if ENV['X_PACT_DEVELOPMENT'] == 'true'
    gem 'pact', path: '../pact-ruby'
    gem 'pact-ffi', path: '../pact-ffi'
  else
    gem 'pact'
    gem 'pact-ffi'
  end
  # for pact/v2 with non rail apps
  gem 'activesupport'
end

group :test do
  gem 'faraday', '~>2.0'
  gem 'faraday-retry', '~>2.0'
  gem 'rack', '~> 3.0'
  gem 'rackup', '~> 2.1'
end
