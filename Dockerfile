FROM ruby:4.0.5-alpine@sha256:f48938e9ae72a4d32e728b03c306e7a7ff21f0cb6c2ed33f44a078c700b2aea6

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
