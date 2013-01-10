require 'spec_helper'
require 'json'

describe Hitimes::Stats do
  before( :each ) do
    @stats = Hitimes::Stats.new
    @full_stats = Hitimes::Stats.new
    
    [ 1, 2, 3].each { |i| @full_stats.update( i ) }
  end

  it "is initialized with 0 values" do
    @stats.count.should be == 0
    @stats.min.should be == 0.0
    @stats.max.should be == 0.0
    @stats.sum.should be == 0.0
    @stats.rate.should be == 0.0
  end

  it "calculates the mean correctly" do
    @full_stats.mean.should be == 2.0
  end

  it "calculates the rate correctly" do
    @full_stats.rate.should be == 0.5
  end

  it "tracks the maximum value" do
    @full_stats.max.should be == 3.0
  end

  it "tracks the minimum value" do
    @full_stats.min.should be == 1.0
  end

  it "tracks the count" do
    @full_stats.count.should be == 3
  end
  
  it "tracks the sum" do
    @full_stats.sum.should be == 6.0
  end

  it "calculates the standard deviation" do
    @full_stats.stddev.should be == 1.0
  end 

  it "calculates the sum of squares " do
    @full_stats.sumsq.should be == 14.0
  end 

  describe "#to_hash " do
    it "converts to a Hash" do
      h = @full_stats.to_hash
      h.size.should be == ::Hitimes::Stats::STATS.size
      h.keys.sort.should be == ::Hitimes::Stats::STATS
    end

    it "converts to a limited Hash if given arguments" do
      h = @full_stats.to_hash( "min", "max", "mean" )
      h.size.should be == 3
      h.keys.sort.should be == %w[ max mean min  ]

      h = @full_stats.to_hash( %w[ count rate ] )
      h.size.should be == 2
      h.keys.sort.should be == %w[ count rate ]
    end

    it "raises NoMethodError if an invalid stat is used" do
      lambda { @full_stats.to_hash( "wibble" ) }.should raise_error( NoMethodError )
    end
  end

  describe "#to_json" do
    it "converts to a json string" do
      j = @full_stats.to_json
      h = JSON.parse( j )
      h.size.should be == ::Hitimes::Stats::STATS.size
      h.keys.sort.should be == ::Hitimes::Stats::STATS
    end

    it "converts to a limited Hash if given arguments" do
      j = @full_stats.to_json( "min", "max", "mean" )
      h = JSON.parse( j )
      h.size.should be == 3
      h.keys.sort.should be == %w[ max mean min  ]

      j = @full_stats.to_json( %w[ count rate ] )
      h = JSON.parse( j )
      h.size.should be == 2
      h.keys.sort.should be == %w[ count rate ]
    end

    it "raises NoMethodError if an invalid stat is used" do
      lambda { @full_stats.to_json( "wibble" ) }.should raise_error( NoMethodError )
    end
  end
end
