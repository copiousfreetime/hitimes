require 'hitimes/initialize'

module Hitimes
  # Public: The clock_id to use in Process.clock_gettime
  CLOCK_ID                        = Initialize.determine_clock_id.freeze

  # Public: The resolution of the clock
  CLOCK_RESOLUTION_IN_NANOSECONDS = Process.clock_getres(CLOCK_ID, :nanosecond).freeze

  # Internal: The fraction of second of a nanosecond
  NANOSECONDS_PER_SECOND                 = 1e9

  # Public: The same as CLOCK_RESOLUTION here for API compatibility with
  # previous versions of Hitimes.
  #
  # The raw instant values are divided by this value to get float seconds
  INSTANT_CONVERSION_FACTOR  = CLOCK_RESOLUTION_IN_NANOSECONDS * NANOSECONDS_PER_SECOND


  # Public: Get the raw instant
  #
  # Examples:
  #
  #    Hitimes.raw_instant
  #
  # Returns the raw instant value
  def raw_instant
    Process.clock_gettime(::Hitimes::CLOCK_ID, :nanosecond)
  end
  module_function :raw_instant

  # Internal: The human readable clock description of the CLOCK_ID as a string
  #
  # Returns the clock description as a String
  def clock_description
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
  module_function :clock_description
end
