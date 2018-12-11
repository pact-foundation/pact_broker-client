FROM ruby:2.5.3-alpine3.7
RUN gem install pact_broker-client
CMD ["/bin/sh"]
