# frozen_string_literal: true

module Hitimes
  # Internal: Internal setup that is done when the library is loaded
  #
  # We want to determine what clock to use for this machine. So we need to
  # introspect the ruby environment and then setup some initial constants. These
  # methods are used in lib/hitimes/instant.rb to help setup the CLOCK_ID
  # constant at load time.
  #
  module Initialize
    #
    # After a fair bit of experimentaiton, it seems that the only clock_ids that
    # are of any use are the following:
    #
    # POSIX:
    #
    #   CLOCK_REALTIME   A settable system-wide real-time clock. Measures
    #                    wall-clock time. Affected by system jumps in time,
    #                    adjtime(3), and NTP.
    #
    #   CLOCK_MONOTONIC  A nonsettable system-wide clock that represent
    #                    monotomic time since some unspecified point in the
    #                    past. Not affected by jumps in system time, but is
    #                    affectd by adjtime(3) and NTP.
    #
    # Darwin:
    #
    #   CLOCK_MONOTONIC_RAW  clock that increments monotonically, tracking the
    #                        time since an arbitrary point like CLOCK_MONOTONIC.
    #                        However, this clock is unaffected by frequency or
    #                        time adjustments.
    #
    #   CLOCK_UPTIME_RAW  clock that increments monotonically, in the same manner
    #                     as CLOCK_MONOTONIC_RAW, but that does not increment
    #                     while the system is asleep.  The returned value is
    #                     identical to the result of mach_absolute_time()
    #                     after the appropriate mach_timebase conversion is applied.
    #
    # Linux:
    #
    #   CLOCK_MONOTONIC_RAW  Similar to CLOCK_MONOTONIC, but provides access to
    #                        a raw hardware-based time that is not subject to NTP
    #                        adjustments or the incremental adjustments performed
    #                        by adjtime(3)
    #
    #   CLOCK_BOOTTIME  Identical to CLOCK_MONOTONIC, except it also includes any
    #                   time that the system is suspended.
    #
    # *BSD:
    #
    #   All the BSDs seem to have CLOCK_MONOTONIC and CLOCK_REALTIME although on
    #   NetBSD CLOCK_MONOTONIC is not affected by adjtime(2). It is unclear if 
    #   they are affected by adjtime(2) on FreeBSD, OpenBSD, or DragonFlyBSD. -
    #   at least according to the man pages.
    #
    # What this boils down to as that pretty much all systems have CLOCK_REALTIME
    # and CLOCK_MONOTONIC. The other clocks are system specific and may or may
    # not exist. We'll try to use the most accurate clock available.
    #
    # So we'll try to use the following clocks in order of preference:
    #
    # On Linux and Darwin
    #   CLOCK_MONOTONIC_RAW, CLOCK_MONOTONIC, CLOCK_REALTIME
    #
    # Everyone else:
    #   CLOCK_MONOTONIC, CLOCK_REALTIME
    #
    # So in reality, well just test for constants on all of the above and use the
    # first one that exists.
    #
    # If CLOCK_REALTIME is chose, we will dump a warning to the user.
    # And if we can't finde one, which is really, really odd, we'll raise an exception.
    POTENTIAL_CLOCK_IDS = %i[ CLOCK_MONOTONIC_RAW CLOCK_MONOTONIC CLOCK_REALTIME].freeze
    def determine_clock_id(potential_ids = POTENTIAL_CLOCK_IDS)
      sym = potential_ids.find { |c| Process.const_defined?(c) }

      if :CLOCK_REALTIME == sym
        warn <<~TXT
        Unable to find a high resolution clock. Using CLOCK_REALTIME for timing.

        RUBY_DESCRIPTION: #{RUBY_DESCRIPTION}

        Please report the above information hitimes issue tracker at
        https://github.com/copiousfreetime/hitimes/issuest
        TXT
      elsif sym.nil?
        raise Hitimes::Error, <<~ERROR
        Unable to find a high resolution clock at all. THIS IS A BUG!!

        RUBY_DESCRIPTION: #{RUBY_DESCRIPTION}

        Please report this bug to the hitimes issue tracker at
        https://github.com/copiousfreetime/hitimes/issues
        ERROR
      end

      Process.const_get(sym)
    end
    module_function :determine_clock_id
  end
end
