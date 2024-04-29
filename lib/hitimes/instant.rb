# frozen_string_literal: true

require "hitimes/initialize"

# Hitimes Constants and module methods
#
module Hitimes
  # Public: The clock_id to use in Process.clock_gettime
  CLOCK_ID                        = Initialize.determine_clock_id.freeze

  # Internal: The fraction of second of a nanosecond
  NANOSECONDS_PER_SECOND          = 1e9

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
      const = Process.constants.grep(/CLOCK/).find do |c|
        Process.const_get(c) == CLOCK_ID
      end
      "Process::#{const}"
    end
  end
  module_function :clock_name
end
