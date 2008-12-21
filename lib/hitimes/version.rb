#--
# Copyright (c) 2008 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details
#++

module Hitimes
  #
  # module containing all the version information about Hitimes
  #
  module Version

    MAJOR   = 0
    MINOR   = 4
    BUILD   = 0

    # 
    # :call-seq:
    #   Version.to_a -> [ MAJOR, MINOR, BUILD ]
    #
    # Return the version as an array of Integers
    #
    def to_a 
      [MAJOR, MINOR, BUILD]
    end

    #
    # :call-seq:
    #   Version.to_s -> MAJOR.MINOR.BUILD
    #
    # Return the version as a String with dotted notation
    #
    def to_s
      to_a.join(".")
    end

    module_function :to_a
    module_function :to_s

    STRING = Version.to_s
  end
  VERSION = Version.to_s
end
