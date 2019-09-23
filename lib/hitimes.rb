#--
# Copyright (c) 2008 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++

#
# The top level module containing the contents of the hitimes library
#
# use the library with:
#
#   require 'hitimes'
#
module Hitimes
  #
  # Base class of all errors in Hitimes
  #
  class Error < ::StandardError; end

  # Hitimes.measure { } -> Float
  #
  # Times the execution of the block, returning the number of seconds it took
  def self.measure(&block)
    Hitimes::Interval.measure(&block)
  end
end
require 'hitimes/paths'
require 'hitimes/version'
require 'hitimes/instant'
require 'hitimes/interval'

require 'hitimes/stats'
require 'hitimes/mutexed_stats'

require 'hitimes/metric'
require 'hitimes/value_metric'
require 'hitimes/timed_metric'
require 'hitimes/timed_value_metric'

