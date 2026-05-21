# frozen_string_literal: true

require "hitimes"
require "minitest/focus"
require "minitest/pride"

# Assertions for comparing float values where precision loss may cause strict
# comparisons to fail. This happens when comparing UTC microsecond timestamps
# that are computed and then mulitpled by 1_000_000 to compare microseconds.
#
# Depending on the real time clock and other things, the values need a little
# bit of epislon, similar to the existing assert_in_epsilon, but we want to only
# assert within a particular direction. And this is jitter that might be
# suseptible to JVM gc and other things, so making it a reasonable size
#
# The default tolerance of 100 microseconds is well within the minitest default
# epsilon and accounts for the floating point rounding at the magnitude of
# UTC microsecond timestamps.
module Minitest
  TIMING_TOLERANCE = 10_000.0

  module Assertions
    # Assert that act >= exp - delta
    # "actual is greater than or equal to expected, within delta tolerance"
    def assert_gte_within(exp, act, delta = TIMING_TOLERANCE, msg = nil)
      msg = message(msg) do
        "Expected #{act} to be >= (#{exp} - #{delta}), i.e., >= #{exp - delta}"
      end
      assert act >= (exp - delta), msg
    end

    # Assert that act <= exp + delta
    # "actual is less than or equal to expected, within delta tolerance"
    def assert_lte_within(exp, act, delta = TIMING_TOLERANCE, msg = nil)
      msg = message(msg) do
        "Expected #{act} to be <= (#{exp} + #{delta}), i.e., <= #{exp + delta}"
      end
      assert act <= (exp + delta), msg
    end
  end

  module Expectations
    infect_an_assertion :assert_gte_within, :must_be_gte_within, :reverse
    infect_an_assertion :assert_lte_within, :must_be_lte_within, :reverse
  end
end
