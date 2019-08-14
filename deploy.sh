#!/usr/bin/env bash
bundle exec middleman build --clean
gsutil cp -r build/* gs://zap-docs/
