#--
# Copyright (c) 2008 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details
#++

module Hitimes
  #
  # module containing all the version information about Hitimes
  #
  module Version

    # Major version number
    MAJOR   = 1

    # Minor version number
    MINOR   = 0

    # Build number
    BUILD   = 1

    #
    # :call-seq:
    #   Version.to_a -> [ MAJOR, MINOR, BUILD ]
    #
    # Return the version as an array of Integers
    #
    def self.to_a
      [MAJOR, MINOR, BUILD]
    end

    #
    # :call-seq:
    #   Version.to_s -> "MAJOR.MINOR.BUILD"
    #
    # Return the version as a String with dotted notation
    #
    def self.to_s
      to_a.join(".")
    end

    #
    # :call-seq:
    #   Version.to_hash -> { :major => ..., :minor => ..., :build => ... }
    #
    # Return the version as a Hash
    #
    def self.to_hash
      { :major => MAJOR, :minor => MINOR, :build => BUILD }
    end

    # The Version in MAJOR.MINOR.BUILD dotted notation
    STRING = Version.to_s
  end

  # The Version in MAJOR.MINOR.BUILD dotted notation
  VERSION = Version.to_s
end
