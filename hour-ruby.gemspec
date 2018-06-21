#!/usr/bin/env gem build
# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'hour-ruby'
  s.version     = '0.0.1'
  s.authors     = ['James C Russell']
  s.email       = 'james@101ideas.cz'
  s.homepage    = 'http://github.com/botanicus/hour-ruby'
  s.summary     = ''
  s.description = "#{s.summary}."
  s.license     = 'MIT'
  s.metadata['yard.run'] = 'yri' # use 'yard' to build full HTML docs.

  s.files       = Dir.glob('{lib,spec}/**/*.rb') + ['README.md']
end

