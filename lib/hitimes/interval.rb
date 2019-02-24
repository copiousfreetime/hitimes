# Copyright (c) 2008 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#
module Hitimes
  # This is the lowest level timing mechanism available.  It allows for easy
  # measuring based upon a block:
  #
  #   duration = Interval.measure { ... }
  #
  # Or measuring something specifically
  #
  #   interval = Interval.new
  #   interval.start
  #   duration = interval.stop
  #
  # Allocating and starting an interval can be done in one method call with
  #
  #   interval = Interval.now
  #
  # Interval is useful when you only need to track a single interval of time, or
  # if you do not want to track statistics about an operation.
  class Interval

    # Public: The integer representing the start instant of the Interval.  This
    # valuea is not useful on its own.  It is a platform dependent value.
    attr_reader :start_instant

    # Public: The integer representing the stop instant of the Interval.  This
    # value is not useful on its own.  It is a platform dependent value.
    attr_reader :stop_instant

    def initialize(start = nil, stop = nil)
      @start_instant = start
      @stop_instant  = stop
      @duration      = -Float::INFINITY
    end

    # call-seq:
    #    Interval.now -> Interval
    #
    # Create an interval that has already started
    #
    def self.now
      Interval.new(Hitimes.raw_instant)
    end

    # call-seq:
    #    Interval.measure {  }  -> Float
    #
    # Times the execution of the block returning the number of seconds it took
    def self.measure(&block)
      raise Error, "No block given to Interval.measure" unless block_given?

      i = Interval.now
      yield
      i.stop

      return i.duration
    end

    # call-seq:
    #    interval.split -> Interval
    #
    # Immediately stop the current interval and start a new interval that has a
    # start_instant equivalent to the stop_interval of self.
    def split
      @stop_instant = ::Hitimes.raw_instant
      return Interval.new(@stop_instant)
    end

    # call-seq:
    #    interval.start -> boolean
    #
    # mark the start of the interval.  Calling start on an already started
    # interval has no effect.  An interval can only be started once.  If the
    # interval is truely started +true+ is returned otherwise +false+.
    def start
      return false if started?
      @start_instant = ::Hitimes.raw_instant
      true
    end

    # call-seq:
    #    interval.stop -> bool or Float
    #
    # mark the stop of the interval.  Calling stop on an already stopped interval
    # has no effect.  An interval can only be stopped once.  If the interval is
    # truely stopped then the duration is returned, otherwise +false+.
    def stop
      raise Error, "Attempt to stop an interval that has not started" unless started?
      return false if stopped?

      @stop_instant = ::Hitimes.raw_instant

      return duration
    end

    # call-seq:
    #     interval.duration_so_far -> Float or false
    #
    # return how the duration so far.  This will return the duration from the time
    # the Interval was started if the interval is running, otherwise it will return
    # false.
    def duration_so_far
      return false unless running?

      _now = Hitimes.raw_instant
      calculate_duration(@start_instant, _now)
    end

    # call-seq:
    #    interval.started? -> boolean
    #
    # returns whether or not the interval has been started
    def started?
      !!@start_instant
    end

    # call-seq:
    #    interval.stopped? -> boolean
    #
    # returns whether or not the interval has been stopped
    def  stopped?
      !!@stop_instant
    end

    # call-seq:
    #    interval.running? -> boolean
    #
    # returns whether or not the interval is running or not.  This means that it
    # has started, but not stopped.
    #
    def running?
      started? && !stopped?
    end

    # call-seq:
    #    interval.duration -> Float
    #    interval.to_f -> Float
    #    interval.to_seconds -> Float
    #    interval.length -> Float
    #
    # Returns the Float value of the interval, the value is in seconds.  If the
    # interval has not had stop called yet, it will report the number of seconds
    # in the interval up to the current point in time.
    #
    # Raises Error if duration is called on an interval that has not started yet.
    #
    def duration
      raise Error, "Attempt to report a duration on an interval that has not started" unless started?

      return duration_so_far unless stopped?

      if @duration < 0 then
        @duration = calculate_duration(@start_instant, @stop_instant)
      end

      return @duration
    end

    alias to_f       duration
    alias to_seconds duration
    alias length     duration

    private

    def calculate_duration(start, stop)
      (stop - start) / ::Hitimes::INSTANT_CONVERSION_FACTOR
    end
  end
end
