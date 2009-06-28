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

# support for fat binaries on windows
if RUBY_PLATFORM =~ /(mswin|mingw)/i
  require "hitimes/#{RUBY_VERSION.sub(/\.\d$/,'')}/hitimes_ext"
else
  require 'hitimes/hitimes_ext'
end
require 'hitimes/stats'
require 'hitimes/mutexed_stats'
require 'hitimes/metric'
require 'hitimes/value_metric'
require 'hitimes/timed_metric'
require 'hitimes/timed_value_metric'

