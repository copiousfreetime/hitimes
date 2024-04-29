module Hitimes
  # Internal: Internal setup that is done when the library is loaded
  #
  # We want to determine what clock to use for this machine. So we need to
  # intropect the ruby environment and then setup some initial constants. These
  # methods are used in lib/hitimes/instant.rb to help setup the CLOCK_ID
  # constant
  #
  module Initialize
    # Internal: Return the list of clock ids, that we are going to test. We'll
    # test to see if it exists, and then do further tests after that.
    #
    # The one requirement is that they are monotonically increasing clocks
    #
    # Returns an array of clock ids
    def potential_clock_ids
      Array.new.tap do |clock_ids|
        # General monotonic constants in general order of priority. We'll use
        # the first one that matches.
        #
        %i[CLOCK_MONOTONIC_RAW CLOCK_BOOTTIME CLOCK_MONOTONIC].each do |c|
          clock_ids << Process.const_get(c) if Process.const_defined?(c)
        end
      end
    end
    module_function :potential_clock_ids

    # Internal: Determine the resolution of a single clock_id
    #
    # Since clock_getres is not reliable, do this in a different way. Since we
    # can always make `clock_gettime` return in nanosecond resolution, it will
    # have trailing zeros. We're going to pick the number of trailing zeros of
    # the number and use that to guess its resolution.
    #
    # Randomly picked 17 times to call the clock_gettime.
    #
    # * https://bugs.ruby-lang.org/issues/16740
    #
    def resolution_of(clock_id)
      counts = Hash.new(0)
      17.times do
        val = Process.clock_gettime(clock_id, :nanosecond)
        res = if (val % 1_000_000_000).zero? then
                1
              elsif (val % 1_000_000).zero? then
                1e-3
              elsif (val % 1_000).zero? then
                1e-6
              else
                1e-9
              end
        counts[res] += 1
      end

      # now just resolution of the one that has the most values, which will be
      # the last one when sorted.
      ordered = counts.to_a.sort_by { |pair| pair[1] }
      ordered.last[0]
    end
    module_function :resolution_of

    # Internal: Determine what clock to use for the machine we are one. We want
    # the highest resolution clock possible, which should be nanosecond
    # resolution.
    #
    # Get the resolution of each clock id and then return the higest resolution
    # id from the list.
    #
    # Returns the clock id to use on this ruby
    def determine_clock_id
      ids_and_resolutions = potential_clock_ids.map { |clock_id|
        [clock_id, resolution_of(clock_id)]
      }

      # Sort them by the resolution - we want the smallest one first
      ids_and_resolutions.sort_by! { |pair| pair[1] }
      best_clock_and_resolution = ids_and_resolutions[0]

      # return the clock id
      best_clock_and_resolution[0]
    end
    module_function :determine_clock_id
  end
end
