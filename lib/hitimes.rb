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

# Load the binary extension, try loading one for the specific version of ruby
# and if that fails, then fall back to one in the top of the library.
# this is the method recommended by rake-compiler

attempts = [
  "hitimes/#{RUBY_VERSION.sub(/\.\d$/,'')}/hitimes",
  "hitimes/hitimes"
]
loaded = false

exception_messages = []

attempts.each do |path|
  begin
    require path
    loaded = true
  rescue LoadError => ex
    exception_messages << [path, ex.message]
  end
end
unless loaded
  raise LoadError, "Unable to find binary extension, was hitimes installed correctly? " \
    "Attempted paths and error messages: #{exception_messages}"
end

require 'hitimes/stats'
require 'hitimes/mutexed_stats'

require 'hitimes/metric'
require 'hitimes/value_metric'
require 'hitimes/timed_metric'
require 'hitimes/timed_value_metric'

