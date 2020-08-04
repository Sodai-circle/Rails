#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f tmp/pids/server.pid


if [ ! -e Gemfile ]; then
    ls
    echo "初回起動"
    echo "source 'https://rubygems.org'" > Gemfile
    echo "gem 'rails', '~> 6'" >> Gemfile
    echo "" > Gemfile.lock
    bundle install
    rails new . --force --database=mysql
fi;



# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"