#!/usr/bin/env gem build
# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'hour-ruby'
  s.version     = '0.0.3'
  s.authors     = ['James C Russell']
  s.email       = 'james+rubygems@botanicus.me'
  s.homepage    = 'http://github.com/botanicus/hour-ruby'
  s.summary     = "Library for handling hour arithmetics."
  s.description = "#{s.summary} such as addition, multiplication, conversion to decimal etc."
  s.license     = 'MIT'
  s.metadata['yard.run'] = 'yri' # use 'yard' to build full HTML docs.

  s.files       = Dir.glob('{lib,spec}/**/*.rb') + ['README.md']
end

