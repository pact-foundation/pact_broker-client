puts "env: #{ENV["GEM_HOST_API_KEY"].chars.first}"

require 'rubygems/commands/push_command'
include Gem::GemcutterUtilities
puts "gemcutter: #{api_key.chars.first}"