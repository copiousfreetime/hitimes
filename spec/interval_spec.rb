require File.expand_path( File.join( File.dirname( __FILE__ ), "spec_helper.rb" ) )

require 'hitimes_ext'

describe Hitimes::Interval do
  it "has a 0 duration when newly created" do
    i = Hitimes::Interval.new   
    i.duration == 0.0
  end

  it "knows if it has been started" do
    i = Hitimes::Interval.new
    i.should_not be_started

    i.start
    i.should be_started
  end

  it "knows if it has been stopped" do
    i = Hitimes::Interval.new
    i.start
    i.should_not be_stopped
    i.stop
    i.should be_stopped
  end

  it "knows if it is currently running" do
    i = Hitimes::Interval.new
    i.should_not be_running
    i.start
    i.should be_running
    i.stop
    i.should_not be_running
  end

  it "can time a block of code" do
    d = Hitimes::Interval.measure do
      sleep 0.2
    end
    d.should be_close(0.2, 0.01)
  end

  it "raises an error if measure is called with no block" do
    lambda{ Hitimes::Interval.measure }.should raise_error( Hitimes::Error )
  end

  it "creates an interval via #now" do
    i = Hitimes::Interval.now
    i.should be_started
    i.should_not be_stopped
  end

  it "calling duration multiple times returns successivly grater durations" do
    i = Hitimes::Interval.new
    i.start
    y = i.duration
    z = i.duration
    z.should > y
  end

  it "calling start multiple times on has no effect after the first call" do
    i = Hitimes::Interval.new
    i.start.should == true
    x = i.start_instant
    i.start_instant.should > 0
    i.start.should == false
    x.should == i.start_instant
  end

  it "returns the duration on the first call to stop" do
    i = Hitimes::Interval.now
    d = i.stop
    d.should be_instance_of( Float )
  end

  it "calling stop multiple times on has no effect after the first call" do
    i = Hitimes::Interval.new
    i.start.should == true
    i.stop

    x = i.stop_instant
    i.stop_instant.should > 0
    i.stop.should == false
    x.should == i.stop_instant

  end

  it "only calculates duration once after stop is called" do
    i = Hitimes::Interval.new
    i.start
    i.stop
    x = i.duration
    y = i.duration
    x.object_id.should == y.object_id
  end

  describe "#split" do

    it "creates a new Interval object" do
      i = Hitimes::Interval.new
      i.start
      i2 = i.split
      i.object_id.should_not == i2.object_id
    end

    it "with the stop instant equivialent to the previous Interval's start instant" do
      i = Hitimes::Interval.new
      i.start
      i2 = i.split
      i.stop_instant.should == i2.start_instant
    end
  end

end

