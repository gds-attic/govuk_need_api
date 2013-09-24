#!/bin/bash -xe

export RAILS_ENV=test

# This removes rbenv shims from the PATH where there is no
# .ruby-version file. This is because certain gems call their
# respective tasks with ruby -S which causes the following error to
# appear: ruby: no Ruby script found in input (LoadError).
if [ ! -f .ruby-version ]; then
  export PATH=$(printf $PATH | awk 'BEGIN { RS=":"; ORS=":" } !/rbenv/' | sed 's/:$//')
fi

git clean -fdx

bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment

bundle exec rake db:mongoid:drop
bundle exec rake test
