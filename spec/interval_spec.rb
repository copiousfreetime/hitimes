require File.expand_path( File.join( File.dirname( __FILE__ ), "spec_helper.rb" ) )

require 'hitimes_interval'

describe Hitimes::Interval do
  it "has a 0 duration when newly created" do
    i = Hitimes::Interval.new   
    i.duration == 0.0
  end

  it "calling duration multiple times returns successivly graetr durations" do
    i = Hitimes::Interval.new
    i.start!
    y = i.duration
    z = i.duration
    z.should > y
  end

  it "calling start multiple times on has no effect after the first call" do
    i = Hitimes::Interval.new
    i.start!.should == true
    x = i.start_instant
    i.start_instant.should > 0
    i.start!.should == false
    x.should == i.start_instant
  end

  it "calling stop multiple times on has no effect after the first call" do
    i = Hitimes::Interval.new
    i.start!.should == true
    i.stop!

    x = i.stop_instant
    i.stop_instant.should > 0
    i.stop!.should == false
    x.should == i.stop_instant

  end

  it "only calculates duration once after stop! is called" do
    i = Hitimes::Interval.new
    i.start!
    i.stop!
    x = i.duration
    y = i.duration
    x.object_id.should == y.object_id
  end

  describe "#split!" do

    it "creates a new Interval object" do
      i = Hitimes::Interval.new
      i.start!
      i2 = i.split!
      i.object_id.should_not == i2.object_id
    end

    it "with the stop instant equivialent to the previous Interval's start instant" do
      i = Hitimes::Interval.new
      i.start!
      i2 = i.split!
      i.stop_instant.should == i2.start_instant
    end
  end

end

