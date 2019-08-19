# frozen_string_literal: true

class Hour
  # Abstract time unit class.
  #
  # Subclasses are decorating the `Hour` class with functionality
  # specific for their particular type (hours, minutes and seconds).
  #
  # @api private
  class Unit
    def value
      raise NotImplementedError.new("Override in subclasses.")
    end

    def initialize(hour)
      @hour = hour
    end
  end

  class HourUnit < Unit
    def value
      @hour.h
    end

    def round
      self.value + ((0..29).include?(@hour.m) ? 0 : 1)
    end
  end

  class MinuteUnit < Unit
    def value
      @hour.m
    end

    def round
      self.value + ((0..29).include?(@hour.s) ? 0 : 1)
    end

    def total
      @hour.h * 60 + self.value
    end

    def round_total
      self.total + ((0..29).include?(@hour.s) ? 0 : 1)
    end
  end

  class SecondUnit < Unit
    def value
      @hour.s
    end

    def total
      @hour.h * 60 * 60 + @hour.m * 60 + self.value
    end
  end

  # TODO: Test me and document me.
  def self.now(**opts)
    self.from_time(Time.now, **opts)
  end

  # TODO: document and write tests.
  def self.from_time(time, s: true)
    self.new(time.hour, time.min, s ? time.sec : false)
  end

  # Build an hour instance from an hour string.
  #
  #     Hour.parse("1:00:00")
  #     Hour.parse("1:00", "%h:%m?") # Will work with "1:00" or just "1".
  #
  # TODO: Implement me, test me and document me.
  def self.parse(serialised_hour, s: true)
    args = serialised_hour.split(':').map(&:to_i)

    if args.length == 3 && s
      self.new(*args)
    elsif args.length == 2 && !s
      self.new(*(args << false))
    elsif ((0..2).include?(args.length) && s) || ((0..1).include?(args.length) && !s)
      raise ArgumentError, "Too few segments (#{args.inspect})."
    elsif ((4..Float::INFINITY).include?(args.length) && s) || ((3..Float::INFINITY).include?(args.length) && !s)
      raise ArgumentError, "Too many segments (#{args.inspect})."
    end
  end

  # Build an hour instance from *either* **minutes** *or* **seconds**.
  # Unlike `.new`, either of these values can be over 60.
  #
  #     Hour.from(minutes: 85)  # => Hour.new(h: 1, m: 25)
  #     Hour.from(seconds: 120) # => Hour.new(m: 2)
  def self.from(minutes: 0, seconds: 0)
    if minutes != 0 && seconds != 0
      raise ArgumentError.new("Use either minutes OR seconds, not both.")
    end

    if minutes > 0 || (minutes == 0 && seconds == 0)
      self.new(h: minutes / 60, m: minutes % 60)
    else
      self.from(minutes: seconds / 60) + self.new(s: seconds % 60)
    end
  end

  attr_reader :h, :m, :s

  # Build an hour instance from *h*, *m* and *s*.
  # Raises an argument error if *m* or *s* is a value over 60.
  #
  # For instantiating this class from a *minutes* or *seconds* value over 60, use `.from`.
  def initialize(*args)
    if args.length == 1 && args.first.is_a?(Hash)
      initialize_from_keyword_args(**args.first)
    else
      # Pad with 0s.
      args = args + Array.new(3 - args.length, 0)
      @h, @m, @s = args
    end

    if @m > 60
      raise ArgumentError.new("Minutes must be a number between 0 and 60.")
    end

    if @s.respond_to?(:round) && @s > 60
      raise ArgumentError.new("Seconds must be a number between 0 and 60.")
    end
  end

  # Returns a new Hour instance returning the total time of the two hour instances.
  #
  #     Hour.new(m: 25, s: 10) + Hour.new(h: 1) # => Hour.new(1, 25, 10)
  def +(other)
    hours = @h + other.h + (@m + other.m + ((@s + other.s) / 60)) / 60
    minutes = (@m + other.m + ((@s + other.s) / 60)) % 60

    if @s && other.s
      seconds = (@s + other.s) % 60
    elsif (!@s) && (!other.s)
      seconds = false
    else
      raise "TODO: how to resolve this?"
    end

    self.class.new(hours, minutes, seconds)
  end

  def -(other)
    if other.to_decimal > self.to_decimal
      raise ArgumentError, "Negative hours not supported"
    end

    hours = @h - other.h - (@m - other.m - ((@s - other.s) / 60)) / 60
    minutes = (@m - other.m - ((@s - other.s) / 60)) % 60

    if @s && other.s
      seconds = (@s - other.s) % 60
    elsif (!@s) && (!other.s)
      seconds = false
    else
      raise "TODO: how to resolve this?"
    end

    self.class.new(hours, minutes, seconds)
  end

  def *(integer)
    raise ArgumentError, "must be an integer" unless integer.integer?
    self.class.from(seconds: (@h * integer * 3600) + (@m * integer * 60) + (@s * integer))
  end

  # Returns a decorator providing convenience methods for working with hours.
  #
  #     Hour.new(1, 25).hours.round # => 1
  #     Hour.new(1, 45).hours.round # => 2
  def hours
    HourUnit.new(self)
  end

  # Returns a decorator providing convenience methods for working with minutes.
  #
  #     Hour.new(1, 25, 52).minutes.value       # => 25
  #     Hour.new(1, 25, 52).minutes.round       # => 26
  #     Hour.new(1, 25, 52).minutes.total       # => 85
  #     Hour.new(1, 25, 52).minutes.round_total # => 86
  def minutes
    MinuteUnit.new(self)
  end

  # Returns a decorator providing convenience methods for working with seconds.
  #
  #     Hour.new(m: 1, s: 10).seconds.value # => 10
  #     Hour.new(1, 45, 10  ).seconds.total # => (1 * 60 * 60) + (45 * 60) + 10
  def seconds
    SecondUnit.new(self) if @s
  end

  # Returns string representation of the hour instance.
  #
  #     Hour.new(m: 1, s: 10 ).to_s # => "1:10"
  #     Hour.new(1, 45, false).to_s # => "1:45"
  #
  # TODO: Allow formatting string (to format hours to 2 digits etc).
  def to_s(format = nil)
    [(@h unless @h.zero?), format('%02d', @m), (format('%02d', @s) if @s)].compact.join(':')
  end

  alias_method :inspect, :to_s

  # Provisional.
  def to_decimal
    decimal = (@m / 60.0) + (@s / 3600.0)
    "#{@h}.#{decimal}"
    @h + decimal
  end

  def to_time(today = Time.now)
    Time.new(today.year, today.month, today.day, self.hours, self.minutes_over_the_hour)
  end

  [:==, :eql?, :<, :<=, :>, :>=, :<=>].each do |method_name|
    define_method(method_name) do |anotherHour|
      if anotherHour.is_a?(self.class)
        self.seconds.total.send(method_name, anotherHour.seconds.total)
      # elsif anotherHour.is_a?(Time)
      #   self.send(method_name, Hour.now)
      else
        raise TypeError.new("#{self.class}##{method_name} expects #{self.class} or Time object.")
      end
    end
  end

  private
  def initialize_from_keyword_args(h: 0, m: 0, s: 0)
    @h, @m, @s = h, m, s
  end
end

# https://github.com/botanicus/commonjs_modules
export { Hour } if defined?(export)
