require 'hitimes'
require 'hitimes_interval'

module Hitimes
  #
  # A Timer groups together one or more Intervals and provides some basic
  # mechanisms for statistics on Intervals.
  #
  class Timer

    attr_reader :current_interval

    # minimum value of stopped intervals.  
    attr_reader :min

    # maximum value of stopped intervals.  
    attr_reader :max

    # sum of all stopped intervals
    attr_reader :sum

    # sum of squares of all stopped intervals
    attr_reader :sumsq

    # total count of all intervals
    attr_reader :count

    class << self
      # 
      # Return a newly allocated Timer that has already been started
      #
      def now
        t = Timer.new
        t.start
        return t
      end

      # 
      # Return the number of seconds that a block of code took to
      # execute.
      #
      def measure( &block )
        Interval.measure { yield }
      end
    end

    def initialize
      @min = 0.0
      @max = 0.0
      @sum = 0.0
      @sumsq = 0.0
      @count = 0
    end

    def current_interval
      @current_interval ||= Interval.new
    end

    #
    # return whether or not the timer is currently running.  
    #
    def running?
      current_interval.running?
    end

    # 
    # Start the current timer, if the current timer is already started, then
    # this is a noop.  
    #
    def start
      current_interval.start unless running?
      nil
    end

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
        update_stats( d )
        return d
      end
      return false
    end

    #
    # Measure the execution of a block and add those stats to the running stats.
    #
    def measure( &block )
      t = 0.0
      begin
        self.start
        yield
      ensure
        t = self.stop
      end
      return t
    end

    # 
    # The total time the timer has been measuring.  
    #
    def duration
      return sum
    end

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
        update_stats( d )
        @current_interval = next_interval 
        return d
      end 
      return false
    end

    #
    # The mean value of all the the stopped intervals.  The current interval, if
    # it is still running, is not included.
    #
    def mean
      m = 0.0
      m = self.sum / self.count if self.count > 0 
      return m
    end

    #
    # The standard deviation of all the intervals
    #
    def stddev
      begin
        return Math.sqrt( ( @sumsq - ( @sum * @sum / self.count ) ) / ( self.count - 1 ) )
      rescue Errno::EDOM
        return 0.0
      end
    end

    #######
    private
    #######

    # 
    # update the running stats
    #
    def update_stats( new_duration )
      if self.count == 0 then
        @min = @max = new_duration
      else
        @min = new_duration if new_duration < @min 
        @max = new_duration if new_duration > @max
      end

      @count +=1
      @sum   += new_duration
      @sumsq += ( new_duration * new_duration )
    end
  end
end
