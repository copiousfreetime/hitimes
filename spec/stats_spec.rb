require 'spec_helper'
require 'json'

describe Hitimes::Stats do
  before( :each ) do
    @stats = Hitimes::Stats.new
    @full_stats = Hitimes::Stats.new
    
    [ 1, 2, 3].each { |i| @full_stats.update( i ) }
  end

  it "is initialized with usable values" do
    _(@stats.count).must_equal 0
    _(@stats.min).must_equal Float::INFINITY
    _(@stats.max).must_equal(-Float::INFINITY)
    _(@stats.sum).must_equal 0.0
    _(@stats.rate).must_equal 0.0
  end

  it "calculates the mean correctly" do
    _(@full_stats.mean).must_equal 2.0
  end

  it "calculates the rate correctly" do
    _(@full_stats.rate).must_equal 0.5
  end

  it "tracks the maximum value" do
    _(@full_stats.max).must_equal 3.0
  end

  it "tracks the minimum value" do
    _(@full_stats.min).must_equal 1.0
  end

  it "tracks the count" do
    _(@full_stats.count).must_equal 3
  end
  
  it "tracks the sum" do
    _(@full_stats.sum).must_equal 6.0
  end

  it "calculates the standard deviation" do
    _(@full_stats.stddev).must_equal 1.0
  end 

  it "calculates the sum of squares " do
    _(@full_stats.sumsq).must_equal 14.0
  end 

  describe "#to_hash " do
    it "converts to a Hash" do
      h = @full_stats.to_hash
      _(h.size).must_equal ::Hitimes::Stats::STATS.size
      _(h.keys.sort).must_equal ::Hitimes::Stats::STATS
    end

    it "converts to a limited Hash if given arguments" do
      h = @full_stats.to_hash( "min", "max", "mean" )
      _(h.size).must_equal 3
      _(h.keys.sort).must_equal %w[ max mean min  ]

      h = @full_stats.to_hash( %w[ count rate ] )
      _(h.size).must_equal 2
      _(h.keys.sort).must_equal %w[ count rate ]
    end

    it "raises NoMethodError if an invalid stat is used" do
      _(lambda { @full_stats.to_hash( "wibble" ) }).must_raise( NoMethodError )
    end
  end

  describe "#to_json" do
    it "converts to a json string" do
      j = @full_stats.to_json
      h = JSON.parse( j )
      _(h.size).must_equal ::Hitimes::Stats::STATS.size
      _(h.keys.sort).must_equal ::Hitimes::Stats::STATS
    end

    it "converts to a limited Hash if given arguments" do
      j = @full_stats.to_json( "min", "max", "mean" )
      h = JSON.parse( j )
      _(h.size).must_equal 3
      _(h.keys.sort).must_equal %w[ max mean min  ]

      j = @full_stats.to_json( %w[ count rate ] )
      h = JSON.parse( j )
      _(h.size).must_equal 2
      _(h.keys.sort).must_equal %w[ count rate ]
    end

    it "raises NoMethodError if an invalid stat is used" do
      _(lambda { @full_stats.to_json( "wibble" ) }).must_raise( NoMethodError )
    end
  end
end
