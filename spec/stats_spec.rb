require File.expand_path( File.join( File.dirname( __FILE__ ), "spec_helper.rb" ) )

require 'hitimes_ext'

describe Hitimes::Stats do
  before( :each ) do
    @stats = Hitimes::Stats.new
    @full_stats = Hitimes::Stats.new
    
    [ 1, 2, 3].each { |i| @full_stats.update( i ) }
  end

  it "is initialized with 0 values" do
    @stats.count.should == 0
    @stats.min.should == 0.0
    @stats.max.should == 0.0
    @stats.sum.should == 0.0
    @stats.rate.should == 0.0
  end

  it "calculates the mean correctly" do
    @full_stats.mean.should == 2.0
  end

  it "calculates the rate correctly" do
    @full_stats.rate.should == 0.5
  end

  it "tracks the maximum value" do
    @full_stats.max.should == 3.0
  end

  it "tracks the minimum value" do
    @full_stats.min.should == 1.0
  end

  it "tracks the count" do
    @full_stats.count.should == 3
  end
  
  it "tracks the sum" do
    @full_stats.sum.should == 6.0
  end

  it "calculates the standard deviation" do
    @full_stats.stddev.should == 1.0
  end 

  describe "#to_hash " do
    it "converts to a Hash" do
      h = @full_stats.to_hash
      h.size.should == ::Hitimes::Stats::STATS.size
      h.keys.sort.should == ::Hitimes::Stats::STATS
    end

    it "converts to a limited Hash if given arguments" do
      h = @full_stats.to_hash( "min", "max", "mean" )
      h.size.should == 3
      h.keys.sort.should == %w[ max mean min  ]

      h = @full_stats.to_hash( %w[ count rate ] )
      h.size.should == 2
      h.keys.sort.should == %w[ count rate ]
    end

    it "raises NoMethodError if an invalid stat is used" do
      lambda { @full_stats.to_hash( "wibble" ) }.should raise_error( NoMethodError )
    end

  end

end
