#--
# Copyright (c) 2008, 2009 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++

require 'thread'

module Hitimes
  #
  # MutexedStats is the start of a threadsafe Stats class.  Currently, on MRI
  # Ruby the Stats object is already threadsafe, so there is no need to use
  # MutexedStats.
  #
  MutexedStats = Stats
end


