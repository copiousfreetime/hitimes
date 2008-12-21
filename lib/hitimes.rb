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
end
require 'hitimes/paths'
require 'hitimes/version'
require 'hitimes/stats'
require 'hitimes/mutexed_stats'
require 'hitimes/timer'

