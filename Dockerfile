FROM ruby:3.3.8-bookworm

WORKDIR /setup-tmp
COPY Gemfile Gemfile.lock ./
RUN apt-get update && apt-get install -y \
      build-essential \
      vim \
      mariadb-client
RUN bundle install
