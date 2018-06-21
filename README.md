# About

[![Gem version][GV img]][Gem version]
[![Build status][BS img]][Build status]
[![Coverage status][CS img]][Coverage status]
[![CodeClimate status][CC img]][CodeClimate status]
[![YARD documentation][YD img]][YARD documentation]

Hour class to work with hours, minutes and seconds, convert between various units and format the output. _Here's version of this library for Crystal: [hour-crystal](https://github.com/botanicus/hour-crystal)._

# Installation

```yaml
gem install hour-ruby
```

# Usage

```ruby
require "hour"

hour = Hour.from(minutes: 85)
puts "It's #{hour.hours.value}:#{hour.minutes.value}!"

hour = Hour.new(1, 25) + Hour.new(s: 10)
puts "It's #{hour.to_s}!"

puts "The system time is #{Hour.now}!"
```

# TODO

- Rubocop.
- Travis.
- Release version 0.1.

[Gem version]: https://rubygems.org/gems/hour-ruby
[Build status]: https://travis-ci.org/botanicus/hour-ruby
[Coverage status]: https://coveralls.io/github/botanicus/hour-ruby
[CodeClimate status]: https://codeclimate.com/github/botanicus/hour-ruby/maintainability
[YARD documentation]: http://www.rubydoc.info/github/botanicus/hour-ruby/master

[GV img]: https://badge.fury.io/rb/hour-ruby.svg
[BS img]: https://travis-ci.org/botanicus/hour-ruby.svg?branch=master
[CS img]: https://img.shields.io/coveralls/botanicus/hour-ruby.svg
[CC img]: https://api.codeclimate.com/v1/badges/a99a88d28ad37a79dbf6/maintainability
[YD img]: http://img.shields.io/badge/yard-docs-blue.svg
