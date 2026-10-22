FROM ruby:4.0.7-alpine@sha256:280685cbe09c904c386a77ea0b5097eddcf0121504340243f01dadaf51d00801

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing hub
RUN apk add --update --no-cache git openssh bash
RUN gem update --system

RUN mkdir -p home
WORKDIR home
ADD release-image /
ENV BUNDLE_GEMFILE=/release/Gemfile
RUN bundle install
RUN git config --global user.email "beth@bethesque.com"
RUN git config --global user.name "Beth Skurrie via Github Actions"

ENTRYPOINT [/entrypoint.sh]
