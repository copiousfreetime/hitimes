# frozen_string_literal: true

#--
# Copyright (c) 2008, 2009 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++

require "forwardable"
module Hitimes
  #
  # A TimedMetric holds the metrics on how long it takes to do something.  For
  # example, measuring how long a method takes to operate.
  #
  #   tm = TimedMetric.new( 'my-method' )
  #
  #   200.times do
  #     my_method_result = tm.measure do
  #       my_method( ... )
  #     end
  #   end
  #
  #   puts "#{ tm.name } operated at a rate of #{ tm.rate } calls per second"
  #
  # Since TimedMetric is a child class of Metric make sure to look at the
  # Metric API also.
  #
  # A TimedMetric measures the execution time of an option with the Interval
  # class.
  #
  # A TimedMetric contains a Stats object, therefore TimedMetric has +count+, +max+,
  # +mean+, +min+, +rate+, +stddev+, +sum+, +sumsq+ methods that delegate to that Stats
  # object for convenience.
  #
  #
  class TimedMetric < Metric
    # holds all the statistics
    attr_reader :stats

    class << TimedMetric
      #
      # :call-seq:
      #   TimedMetric.now -> TimedMetric
      #
      # Return a TimedMetric that has been started
      #
      def now(name, additional_data = {})
        tm = TimedMetric.new(name, additional_data)
        tm.start
        tm
      end
    end

    #
    # :call-seq:
    #   TimedMetric.new( 'name') -> TimedMetric
    #   TimedMetric.new( 'name', 'other' => 'data') -> TimedMetric
    #
    # Create a new TimedMetric giving it a name and additional data.
    # +additional_data+ may be anything that follows the +to_hash+ protocol
    #
    def initialize(name, additional_data = {})
      super
      @stats            = Stats.new
      @current_interval = Interval.new
    end

    #
    # :call-seq:
    #   timed_metric.running? -> true or false
    #
    # return whether or not the timer is currently running.
    #
    def running?
      @current_interval.running?
    end

    #
    # :call-seq:
    #   timed_metric.start -> nil
    #
    # Start the current metric, if the current metric is already started, then
    # this is a noop.
    #
    def start
      unless @current_interval.running?
        @current_interval.start
        @sampling_start_time ||= utc_microseconds
        @sampling_start_interval ||= Interval.now
      end
      nil
    end

    #
    # :call-seq:
    #   timed_metric.stop -> Float or nil
    #
    # Stop the current metric.  This updates the stats and removes the current
    # interval. If the timer was stopped then the duration of the last Interval
    # is returned.  If the timer was already stopped then false is returned and
    # no stats are updated.
    #
    def stop
      if @current_interval.running?
        duration = @current_interval.stop
        @stats.update(duration)
        @current_interval = Interval.new

        # update the length of time we have been sampling
        @sampling_delta = @sampling_start_interval.duration_so_far

        return duration
      end
      false
    end

    #
    # :call-seq:
    #   timed_metric.measure {  ... } -> Object
    #
    # Measure the execution of a block and add those stats to the running stats.
    # The return value is the return value of the block
    #
    def measure
      return_value = nil
      begin
        start
        return_value = yield
      ensure
        stop
      end
      return_value
    end

    #
    # :call-seq:
    #   timed_metric.split -> Float
    #
    # Split the current TimedMetric.  Essentially, mark a split time. This means
    # stop the current interval and create a new interval, but make sure
    # that the new interval lines up exactly, timewise, behind the previous
    # interval.
    #
    # If the timer is running, then split returns the duration of the previous
    # interval, i.e. the split-time.  If the timer is not running, nothing
    # happens and false is returned.
    #
    def split
      if @current_interval.running?
        next_interval = @current_interval.split
        duration = @current_interval.duration
        @stats.update(duration)
        @current_interval = next_interval
        return duration
      end
      false
    end

    #
    # :call-seq:
    #   metric.to_hash -> Hash
    #
    # Convert the metric to a hash
    #
    def to_hash
      result = super
      Stats::STATS.each do |stat|
        result[stat] = send(stat)
      end
      result
    end

    # forward appropriate calls directly to the stats object
    extend Forwardable
    def_delegators :@stats, :count, :max, :mean, :min, :rate, :stddev, :sum, :sumsq
    alias duration sum
  end
end
