#--
# Copyright (c) 2008, 2009 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++

require 'hitimes'
require 'forwardable'
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
      def now( name, additional_data = {} )
        t = TimedMetric.new( name, additional_data )
        t.start
        return t
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
    def initialize( name, additional_data = {} )
      super( name, additional_data )
      @stats            = Stats.new
      @current_interval = nil
    end

    #
    # :call-seq:
    #   timed_metric.current_interval -> Interval
    #
    # Return the current interval, if one doesn't exist create one.
    #
    def current_interval
      @current_interval ||= Interval.new
    end

    #
    # :call-seq:
    #   timed_metric.running? -> true or false
    #
    # return whether or not the timer is currently running.  
    #
    def running?
      current_interval.running?
    end

    # 
    # :call-seq:
    #   timed_metric.start -> nil
    #
    # Start the current timer, if the current timer is already started, then
    # this is a noop.  
    #
    def start
      current_interval.start unless running?
      @sampling_start_time ||= self.utc_microseconds() 
      nil
    end

    #
    # :call-seq:
    #   timed_metric.stop -> Float or nil
    #
    # Stop the current timed_metric.  This updates the stats and removes the current
    # interval. If the timer is not running then this is a noop.  If the
    # timer was stopped then the duration of the last Interval is returned.  If
    # the timer was already stopped then false is returned.
    # 
    def stop
      if running? then
        d = current_interval.stop
        @current_interval = nil
        @sampling_stop_time = self.utc_microseconds()
        @stats.update( d )
        return d
      end
      return false
    end

    #
    # :call-seq:
    #   timed_metric.measure {  ... } -> Object
    #
    # Measure the execution of a block and add those stats to the running stats.
    # The return value is the return value of the block
    #
    def measure( &block )
      return_value = nil
      begin
        start
        return_value = yield
      ensure
        stop
      end
      return return_value
    end

    #
    # :call-seq:
    #   timed_metric.split -> Float
    #
    # Split the current timed_metric.  Essentially, mark a split time. This means
    # stop the current interval and create a new interval, but make sure
    # that the new interval lines up exactly, timewise, behind the previous
    # interval.
    #
    # If the timer is running, then split returns the duration of the previous
    # interval, i.e. the split-time.  If the timer is not running, nothing
    # happens and false is returned.
    #
    def split  
      if running? then 
        next_interval = current_interval.split
        d = current_interval.duration
        @stats.update( d )
        @current_interval = next_interval 
        return d
      end 
      return false
    end

    # forward appropriate calls directly to the stats object
    extend Forwardable
    def_delegators :@stats, :count, :sum, :max, :mean, :min, :rate, :stddev, :sum, :sumsq
    alias :duration :sum
  end
end
