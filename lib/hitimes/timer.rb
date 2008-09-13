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
      @current_interval = nil
    end
  
    def start!
    end
  end
end
