require 'hitimes/initialize'

module Hitimes

  # Public: The clock_id to use in Process.clock_gettime
  CLOCK_ID                  = determine_clock_id.freeze

  # Public: The resolution of the clock
  CLOCK_RESOLUTION          = Process.clock_getres(CLOCK_ID).freeze

  # Public: The same as CLOCK_RESOLUTION here for API compatibility with
  # previous versions of Hitimes.
  INSTANT_CONVERSION_FACTOR = CLOCK_RESOLUTION # for api compatibility

  # Internal: The fraction of second of a nanosecond
  NANOSECOND                = 1.0e-9

  # Public: Get the raw instant
  #
  # Examples:
  #
  #    Hitimes.raw_instant
  #
  # Returns the raw instant value
  def self.raw_instant
    Process.clock_gettime(::Hitimes::CLOCK_ID, :nanosecond)
  end

  # Internal: The human readable clock description of the CLOCK_ID as a string
  #
  # Returns the clock description as a String
  def self.clock_description
    case CLOCK_ID
    when Symbol
      CLOCK_ID.to_s
    else
      const = Process.constants.grep(/CLOCK/).find { |c|
        CLOCK_ID == Process.const_get(c)
      }
      "Process::#{const.to_s}"
    end

  end

end
