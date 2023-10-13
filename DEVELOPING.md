# Developing

## Testing pact_broker-client locally

1. Make sure you have `ruby` available on the command line
2. Install with `bundle install`
3. Run tests with `bundle exec rake`
4. Run individual test with `rspec <path to test>`
5. Run one of the scripts in `./example/scripts`, see the readme for more detail, and scripts

##  Available Rake tasks

1. check `bundle exec rake --tasks`

## Generating docs

If you change the CLI commands, run `bundle exec script/update-cli-usage-in-readme.rb` to update the `README.md` automatically.
