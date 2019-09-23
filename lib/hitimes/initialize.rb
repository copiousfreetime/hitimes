module Hitimes

  # Internal: Internal setup that is done when the library is loaded
  #
  # We want to determine what clock to use for this machine. So we need to
  # intropect the ruby environment and then setup some initial constants. These
  # methods are used in lib/hitimes/instant.rb to help setup the CLOCK_ID
  # constant
  #
  module Initialize

    # Internal: Return the list of clock ids, in general priority order,
    # assuming they all have the same resolution.
    #
    # On OSX we probably want to use the MACH time first, and then fall back to
    # CLOCK_... Constants on other machines.
    #
    # The one requirement is that they are monotonically increasing clocks
    #
    # Returns an array of clock ids
    def potential_clock_ids
      Array.new.tap do |clock_ids|

        # if we're on OSX this will add in an additional clock_id, although not
        # sure why it is just a symbol and not a Process:: constant
        #
        begin
          Process.clock_getres(:MACH_ABSOLUTE_TIME_BASED_CLOCK_MONOTONIC)
          clock_ids << :MACH_ABSOLUTE_TIME_BASED_CLOCK_MONOTONIC
        rescue Errno::EINVAL
          # not on OSX
        end

        # General monotonic constants in general order of priority assuming they
        # all have the same resolution
        #
        %i[ CLOCK_MONOTONIC_RAW CLOCK_BOOTTIME CLOCK_MONOTONIC_PRECISE CLOCK_MONOTONIC ].each do |c|
          clock_ids << Process.const_get(c) if Process.const_defined?(c)
        end

      end
    end
    module_function :potential_clock_ids

    # Internal: Determine what clock to use for the machine we are one. We want
    # the highest resolution clock possible, which should be nanosecond
    # resolution.
    #
    # Get the resolution of each clock id and then return the higest resolution
    # id from the list
    #
    # Returns the clock id to use on this ruby
    def determine_clock_id
      ids_and_resolutions = potential_clock_ids.map { |clock_id|
        [clock_id, Process.clock_getres(clock_id)]
      }

      # Sort them by the resolution - we want the smallest one first
      ids_and_resolutions.sort_by! { |pair| pair[1] }

      return ids_and_resolutions.first[0]
    end
    module_function :determine_clock_id
  end
end
