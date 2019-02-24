require 'hitimes/initialize'

module Hitimes
  # Public: The clock_id to use in Process.clock_gettime
  CLOCK_ID                        = Initialize.determine_clock_id.freeze

  # Public: The resolution of the clock
  CLOCK_RESOLUTION_NANOSECONDS    = Process.clock_getres(CLOCK_ID, :nanosecond).freeze

  # Internal: The fraction of second of a nanosecond
  NANOSECONDS_PER_SECOND          = 1e9

  # Public: The smallest fraction of a second hitimes can do
  CLOCK_RESOLUTION_SECONDS        = CLOCK_RESOLUTION_NANOSECONDS / NANOSECONDS_PER_SECOND

  # Public: The factor used to convert the instant values to fractional seconds
  #
  # The raw instant values are divided by this value to get float seconds
  INSTANT_CONVERSION_FACTOR       = CLOCK_RESOLUTION_NANOSECONDS * NANOSECONDS_PER_SECOND


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

  # Internal: The human readable clock name of the CLOCK_ID as a string
  #
  # Returns the clock name as a String
  def clock_name
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
  module_function :clock_name

  # Internal: The human readable clock resolution
  #
  # Returns the clock resolution as a string
  def clock_resolution_description
    "#{CLOCK_RESOLUTION_NANOSECONDS}ns"
  end
  module_function :clock_resolution_description

  # Internal: The human readable clock description that is used by hitimes
  #
  # Returns the clock description as a String
  def clock_description
    "#{clock_name} #{clock_resolution_description}"
  end
  module_function :clock_description
end
