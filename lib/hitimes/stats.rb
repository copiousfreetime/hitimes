#--
# Copyright (c) 2008, 2009 Jeremy Hinegardner
# All rights reserved.  See LICENSE and/or COPYING for details.
#++

require 'stringio'
require 'thread'
module Hitimes
  #
  # The Stats class encapulsates capturing and reporting statistics.  It is
  # modeled after the RFuzz::Sampler class, but implemented in C.  For general use
  # you allocate a new Stats object, and then update it with new values.  The
  # Stats object will keep track of the _min_, _max_, _count_, _sum_ and _sumsq_ 
  # and when you want you may also retrieve the _mean_, _stddev_ and _rate_.
  #
  # this contrived example shows getting a list of all the files in a directory
  # and running stats on file sizes.
  #
  #     s = Hitimes::Stats.new
  #     dir = ARGV.shift || Dir.pwd
  #     Dir.entries( dir ).each do |entry|
  #       fs = File.stat( entry )
  #       if fs.file? then
  #         s.update( fs.size )
  #        end
  #     end
  #
  #     %w[ count min max mean sum stddev rate ].each do |m|
  #       puts "#{m.rjust(6)} : #{s.send( m ) }"
  #     end
  #
  class Stats
    # A list of the available stats
    STATS = %w[ count max mean min rate stddev sum sumsq ]

    attr_reader :min
    attr_reader :max
    attr_reader :count
    attr_reader :sum
    attr_reader :sumsq

    def initialize
      @mutex = Mutex.new
      @min = Float::INFINITY
      @max = -Float::INFINITY
      @count = 0
      @sum = 0.0
      @sumsq = 0.0
    end

    # call-seq:
    #    stat.update( val ) -> val
    #
    # Update the running stats with the new value.
    # Return the input value.
    def update(value)
      @mutex.synchronize do
        @min = (value < @min) ? value : @min
        @max = (value > @max) ? value : @max

        @count += 1
        @sum   += value
        @sumsq += (value * value)
      end

      return value
    end

    # call-seq:
    #    stat.mean -> Float
    # 
    # Return the arithmetic mean of the values put into the Stats object.  If no
    # values have passed through the stats object then 0.0 is returned;
    def mean
      return 0.0 if @count.zero?
      return @sum / @count
    end

    # call-seq:
    #    stat.rate -> Float
    #
    # Return the +count+ divided by +sum+.
    #
    # In many cases when Stats#update( _value_ ) is called, the _value_ is a unit
    # of time, typically seconds or microseconds.  #rate is a convenience for those
    # times.  In this case, where _value_ is a unit if time, then count divided by
    # sum is a useful value, i.e. +something per unit of time+.
    #
    # In the case where _value_ is a non-time related value, then the value
    # returned by _rate_ is not really useful.
    #
    def rate
      return 0.0 if @sum.zero?
      return @count / @sum
    end

    #
    # call-seq:
    #    stat.stddev -> Float
    #
    # Return the standard deviation of all the values that have passed through the
    # Stats object.  The standard deviation has no meaning unless the count is > 1,
    # therefore if the current _stat.count_ is < 1 then 0.0 will be returned;
    #
    def stddev
      return 0.0 unless @count > 1
      Math.sqrt((@sumsq - ((@sum * @sum)/@count)) / (@count - 1))
    end

    # 
    # call-seq:
    #   stat.to_hash   -> Hash
    #   stat.to_hash( %w[ count max mean ]) -> Hash
    #
    # return a hash of the stats.  By default this returns a hash of all stats
    # but passing in an array of items will limit the stats returned to only
    # those in the Array. 
    #
    # If passed in an empty array or nil to to_hash then STATS is assumed to be
    # the list of stats to return in the hash.
    #
    def to_hash( *args )
      h = {}
      args = [ args ].flatten
      args = STATS if args.empty?
      args.each do |meth|
        h[meth] = self.send( meth )
      end
      return h
    end

    #
    # call-seq:
    #   stat.to_json  -> String
    #   stat.to_json( *args ) -> String
    #
    # return a json string of the stats.  By default this returns a json string
    # of all the stats.  If an array of items is passed in, those that match the
    # known stats will be all that is included in the json output.
    #
    def to_json( *args )
      h = to_hash( *args )
      a = []
      s = StringIO.new

      s.print "{ "
      h.each_pair do |k,v|
        a << "\"#{k}\": #{v}"
      end
      s.print a.join(", ")
      s.print "}"
      return s.string
    end
  end
end
