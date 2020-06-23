#!/bin/bash

# Fast fail the script on failures.
set -e
set -x

if [ "$TRAVIS_DART_VERSION" = "dev" ]; then
  dartfmt -n --set-exit-if-changed .
fi

# The lib dir should analyzer without enabling the experiment
dartanalyzer --fatal-warnings --fatal-infos lib
# The whole package should analyze with the experiment enabled 
dartanalyzer --fatal-warnings --fatal-infos --enable-experiment=non-nullable .

# Run the tests.
pub run --enable-experiment=non-nullable test

# Install dart_coveralls; gather and send coverage data.
if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "dev" ]; then
  pub global activate dart_coveralls
  pub global run dart_coveralls report \
    --token $COVERALLS_TOKEN \
    --retry 2 \
    --exclude-test-files \
    test/test_all.dart
fi
