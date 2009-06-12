#--
# Copyright (c) 2008, 2009 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++
#
require 'hitimes/stats'
module Hitimes
  #
  # A ValueMetric holds the data from measuring a single value over a period of
  # time.  In most cases this may be a single measurement at a single point in
  # time.
  #
  # A good example of a ValueMetric is measuring the number of items in a queue.
  #
  class ValueMetric
    # holds all the statistics
    attr_reader :stats

    # the time at which the first sample was taken
    # This is the number of microseconds since UNIX epoch as a Float in UTC
    attr_reader :sampling_start_time

    # the time at which the last sample was taken.
    # This is the number of microseconds since UNIX epoch as a Float in UTC
    attr_reader :sampling_stop_time

    # An additional hash of data to associate with the metric
    attr_reader :additional_data

    # The 'name' to associate with the metric
    attr_reader :name

    #
    # :call-seq:
    #   ValueMetric.new( 'my_metric' ) -> ValueMetric
    #   ValueMetric.new( 'my_metric', 'foo' => 'bar', 'this' => 42 ) -> ValueMetric
    #
    # Create a new ValueMetric giving it a name and additional data.
    # +additional_data+ may be anything that follows the +to_hash+ protocol.
    #
    def initialize( name, additional_data = {} )
      @name                = name
      @stats               = Stats.new
      @sampling_start_time = nil
      @sampling_stop_time  = nil
      @additional_data     = additional_data.to_hash
    end

    #
    # :call-seq:
    #   metric.measure( value ) -> Float
    #
    # Give the +value+ as the measurement to the metric.  The value is returned
    #
    def measure( value )
      now = self.utc_microseconds()
      @sampling_start_time ||= now
      @sampling_stop_time = now
      @stats.update( value )
    end

    # 
    # :call-seq:
    #   metric.sum -> Float
    #
    # The total of all the measurements the metric has obtained.
    #
    def sum
      stats.sum
    end

    #
    # :call-seq:
    #   metric.mean -> Float
    #
    # The mean value of all the the measurements
    #
    def mean
      stats.mean
    end

    #
    # :call-seq:
    #   metric.stddev -> Float
    #
    # The standard deviation of all the measurements
    #
    def stddev
      stats.stddev
    end

    #
    # :call-seq:
    #   metric.count -> Integer
    #
    # The count of measurements taken
    #
    def count
      stats.count
    end

    #
    # :call-seq:
    #   metric.max -> Float
    #
    # The maximum measurement taken by this metric
    # 
    def max
      stats.max
    end

    #
    # :call-seq:
    #   metric.min -> Float
    #
    # The minimum measurement taken by this metric
    #
    def min
      stats.min
    end

    #
    # :call-seq:
    #   metric.utc_microseconds -> Float
    #
    # The current time in microseconds from the UNIX Epoch in the UTC
    #
    def utc_microseconds
      Time.now.gmtime.to_f * 1_000_000
    end
  end
end
