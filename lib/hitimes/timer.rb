require 'hitimes'
require 'hitimes_interval'

module Hitimes
  #
  # A Timer groups together one or more Intervals and provides some basic
  # mechanisms for statistics on Intervals.
  #
  class Timer

    attr_reader :intervals
    attr_reader :current_interval

    # minimum value of stopped intervals.  
    attr_reader :min

    # maximum value of stopped intervals.  
    attr_reader :max

    # sum of all stopped intervals
    attr_reader :sum

    # sum of squares of all stopped intervals
    attr_reader :sumsq

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
        i = Interval.new
        begin
          i.start 
          yield
        ensure
          i.stop
        end
        return i.duration
      end
    end

    def initialize
      @intervals = []
      @min = 0.0
      @max = 0.0
      @sum = 0.0
      @sumsq = 0.0
      new_current_interval
    end

    #
    # return whether or not the timer is currently running.  
    #
    def running?
      current_interval.started? and not current_interval.stopped?
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
    # Stop the current timer.  This pushes the current interval onto the
    # interval list.  If the timer is not running then this is a noop.  If the
    # timer was stopped then the duration of the last Interval is returned.  If
    # the timer was already stopped then false is returned.
    # 
    def stop
      if running? then
        current_interval.stop
        self.intervals << current_interval
        new_current_interval
        update_stats
        return self.intervals.last.duration
      end
      return false
    end

    #
    # Measure the execution of a block and append that interval to the interval
    # list.  Also return the duration of the interval.
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
    # The total time the timer has been measuring.  This is the sum of all
    # interval durations that are stopped.  The current interval, if it is still
    # running, is not included.
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
        new_interval = current_interval.split
        self.intervals << current_interval 
        @current_interval = new_interval 
        update_stats  
        return self.intervals.last.duration
      end 
      return false
    end

    #
    # The number of intervals usable in calculations, this is the number of
    # stopped intervals.  The current interval, if it is still running, is not
    # included.
    #
    def count
      intervals.size 
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

    def new_current_interval
      @current_interval = Interval.new
    end

    # 
    # update the running stats
    #
    def update_stats
      new_duration = self.intervals.last.duration
      if self.count == 1 then
        @min = @max = new_duration
      else
        @min = new_duration if new_duration < @min 
        @max = new_duration if new_duration > @max
      end
      @sum    += new_duration
      @sumsq  += ( new_duration * new_duration )
    end
  end
end
