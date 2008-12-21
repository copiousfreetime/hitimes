module Hitimes
  class Stats
    # A list of the available stats
    STATS = %w[ count max mean min rate stddev sum ]

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

  end
end
