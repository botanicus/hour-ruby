# About
[![Build status][BS img]][Build status]

Hour class to work with hours, minutes and seconds, convert between various units and format the output.

# Installation

```yaml
gem install hour-ruby
```

# Usage

```crystal
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
- Link hour-crystal.
- Release version 0.1.

[Build status]: https://travis-ci.org/botanicus/hour-ruby
[BS img]: https://travis-ci.org/botanicus/hour-ruby.svg?branch=master
