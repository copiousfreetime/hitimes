# Hitimes
[![Build Status](https://copiousfreetime.semaphoreci.com/badges/hitimes/branches/main.svg)](https://copiousfreetime.semaphoreci.com/projects/hitimes)

* [Homepage](http://github.com/copiousfreetime/hitimes)
* [Github project](http://github.com/copiousfreetime/hitimes)

## DESCRIPTION

A fast, high resolution timer library for recording peformance metrics.

## TABLE OF CONTENTS

* [Requirements](#requirements)
* [Usage](#usage)
* [Contributing](#contributing)
* [Support](#support)
* [License](#license)


## REQUIREMENTS

Hitimes requires the following to run:

  * Ruby

## USAGE

Hitimes easiest to use when installed with `rubygems`:

```sh
gem install hitimes
```

Or as part of your bundler `Gemfile`:

```ruby
gem "hitimes"
```

You can load it with the standard ruby require statement.

```ruby
require "hitimes"
```

### Interval

Use `Hitimes::Interval` to calculate only the duration of a block of code.
Returns the time as seconds.

```ruby
duration = Hitimes::Interval.measure do
  1_000_000.times do |x|
    2 + 2
  end
end

puts duration  # => 0.047414297 (seconds)
```

### TimedMetric

Use a `Hitimes::TimedMetric` to calculate statistics about an iterative operation

```ruby
timed_metric = Hitimes::TimedMetric.new("operation on items")
```

Explicitly use `start` and `stop`:

```ruby
collection.each do |item|
  timed_metric.start
  # .. do something with item
  timed_metric.stop
end
```

Or use the block. In `TimedMetric` the return value of `measure` is the return
value of the block.

```ruby
collection.each do |item|
  result_of_do_something = timed_metric.measure { do_something(item) }
  # do something with result_of_do_somthing
end
```
And then look at the stats

```ruby
puts timed_metric.mean
puts timed_metric.max
puts timed_metric.min
puts timed_metric.stddev
puts timed_metric.rate
```

### ValueMetric

Use a `Hitimes::ValueMetric` to calculate statistics about measured samples.

``` ruby
value_metric = Hitimes::ValueMetric.new("size of thing")
loop do
  # ... do stuff changing sizes of 'thing'
  value_metric.measure(thing.size)
  # ... do other stuff that may change size of thing
end

puts value_metric.mean
puts value_metric.max
puts value_metric.min
puts value_metric.stddev
puts value_metric.rate
```

### TimedValueMetric

Use a `Hitimes::TimedValueMetric` to calculate statistics about batches of samples.

``` ruby
timed_value_metric = Hitimes::TimedValueMetric.new("batch times")
loop do
  batch = ... # get a batch of things
  timed_value_metric.start
  # .. do something with batch
  timed_value_metric.stop(batch.size)
end

puts timed_value_metric.rate

puts timed_value_metric.timed_stats.mean
puts timed_value_metric.timed_stats.max
puts timed_value_metric.timed_stats.min
puts timed_value_metric.timed_stats.stddev

puts timed_value_metric.value_stats.mean
puts timed_value_metric.value_stats.max
puts timed_value_metric.value_stats.min
puts timed_value_metric.value_stats.stddev
```

### Implementation details

Hitimes uses the internal ruby `Process::clock_gettime()` to
get the highest granularity time increment possible. Generally this is
nanosecond resolution, or whatever the hardware in the CPU supports.

## SUPPORT

Hitimes is supported on whatever versions of ruby are currently supported.
Hitimes also follows [semantic versioning](http://semver.org/).

The current officially supported versions of Ruby are:

* MRI Ruby (all platforms) 3.0 - current
* JRuby 9.4.x.x
* Truffleruby 24

Unofficially supported versions, any version of MRI from Ruby 2.1 and up. Sincd
the C Extension has been removed Hitimes should work with any ruby that is 2.1
or greater as that is when `Process.clock_gettime()` was implemented.

For versions of Ruby before 2.1 please use Hitimes 1.3, the extension code is
still in there and they should still work.

## CONTRIBUTING

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for instructions on development
and bug reporting.

## Credits

* [Bruce Williams](https://github.com/bruce) for suggesting the idea

## License

Hitimes is licensed under the [ISC](https://opensource.org/licenses/ISC)
license.

## Related Works

