require 'hitimes'

module Hitimes
  #
  # A Timer groups together one or more Intervals and provides some basic
  # mechanisms for statistics on Intervals.
  #
  class Timer

    attr_reader :intervals
    attr_reader :current_interval

    def initialize
      @intervals = []
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
    def start!
      current_interval.start! unless running?
      nil
    end

    #
    # Stop the current timer.  This pushes the current interval onto the
    # interval list.  If the timer is not running then this is a noop.
    # 
    def stop!
      if running? then
        current_interval.stop!
        self.intervals << current_interval
        new_current_interval
      end
    end

    #
    # Split the current timer.  Essentially, mark a split time. Tthis means
    # close out the current interval and create a new interval, but make sure
    # that the new interval lines up exactly, timewise behind the current
    # interval.
    #
    # If the timer is not running, then this is a noop
    #

    def split!  
      if running? then 
        new_interval = current_interval.split!
        self.current_intervals << current_interval 
        @current_interval = new_interval 
      end 
    end

    private
    def new_current_interval
      @current_interval = HiTimes::Interval.new
    end
  end
end
