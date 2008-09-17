#--
# Copyright (c) 2008 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++

require 'hitimes'
require 'hitimes_ext'

module Hitimes
  #
  # A Timer combines together an Interval and a Stats object to provide
  # aggregate information about timings.  
  #
  # A Timer has many of the same methods as an Interval and would be used in
  # preference to an Interval in those situations where you want to track
  # statistics about the item you are monitoring.
  #
  class Timer

    # holds all the statistics
    attr_reader :stats

    class << self

      # 
      # :call-seq:
      #   Timer.now -> Timer
      #
      # Return a newly allocated Timer that has already been started
      #
      def now
        t = Timer.new
        t.start
        return t
      end

      # 
      # :call-seq:
      #   Timer.measure { ... } -> Float
      #
      # Return the number of seconds that a block of code took to
      # execute.
      #
      def measure( &block )
        Interval.measure { yield }
      end
    end

    #
    # :call-seq:
    #   Timer.new -> Timer
    #
    def initialize
      @stats = Stats.new
      @current_interval = nil
    end

    #
    # :call-seq:
    #   timer.current_interval -> Interval
    #
    # Return the current interval, if one doesn't exist create one.
    #
    def current_interval
      @current_interval ||= Interval.new
    end

    #
    # :call-seq:
    #   timer.running? -> true or false
    #
    # return whether or not the timer is currently running.  
    #
    def running?
      current_interval.running?
    end

    # 
    # :call-seq:
    #   timer.start -> nil
    #
    # Start the current timer, if the current timer is already started, then
    # this is a noop.  
    #
    def start
      current_interval.start unless running?
      nil
    end

    #
    # :call-seq:
    #   timer.stop -> Float or nil
    #
    # Stop the current timer.  This updates the stats and removes the current
    # interval. If the timer is not running then this is a noop.  If the
    # timer was stopped then the duration of the last Interval is returned.  If
    # the timer was already stopped then false is returned.
    # 
    def stop
      if running? then
        d = current_interval.stop
        @current_interval = nil
        stats.update( d )
        return d
      end
      return false
    end

    #
    # :call-seq:
    #   timer.measure {  ... } -> Float
    #
    # Measure the execution of a block and add those stats to the running stats.
    #
    def measure( &block )
      t = 0.0
      begin
        start
        yield
      ensure
        t = stop
      end
      return t
    end

    #
    # :call-seq:
    #   timer.split -> Flaot
    #
    # Split the current timer.  Essentially, mark a split time. This means
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
        stats.update( d )
        @current_interval = next_interval 
        return d
      end 
      return false
    end

    # 
    # :call-seq:
    #   timer.sum -> Float
    #   timer.duration -> Float 
    #
    # The total time the timer has been measuring.  
    #
    def sum
      stats.sum
    end
    alias duration sum

    #
    # :call-seq:
    #   timer.mean -> Float
    #
    # The mean value of all the the stopped intervals.  The current interval, if
    # it is still running, is not included.
    #
    def mean
      stats.mean
    end

    #
    # :call-seq:
    #   timer.rate -> Float
    #
    # Return the rate of the states, which is the count / duration
    #
    def rate
      stats.rate
    end

    #
    # :call-seq:
    #   timer.stddev -> Float
    #
    # The standard deviation of all the intervals
    #
    def stddev
      stats.stddev
    end

    #
    # :call-seq:
    #   timer.count -> Integer
    #
    # The count of intervals in this timer
    #
    def count
      stats.count
    end

    #
    # :call-seq:
    #   timer.max -> Float
    #
    # The maximum duration of all the intervals this Timer has seen
    # 
    def max
      stats.max
    end

    #
    # :call-seq:
    #   timer.min -> Float
    #
    # The minimum duration of all the intervals this Timer has seen
    #
    def min
      stats.min
    end
  end
end
