FROM ruby:3.3 AS base
ENV RUBY_YJIT_ENABLE=1
WORKDIR /app

COPY . .
CMD ["rake", "test"]