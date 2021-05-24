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
  gem 'pry-byebug'
end