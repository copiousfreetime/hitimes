require "spec_helper"

describe Hitimes::Interval do
  it "raises an error if duration is called on a non-started interval" do
    i = Hitimes::Interval.new
    lambda{ i.duration }.should raise_error( Hitimes::Error, /\AAttempt to report a duration on an interval that has not started\Z/ )
  end

  it "raises an error if stop is called on a non-started interval" do
    i = Hitimes::Interval.new
    lambda { i.stop }.should raise_error( Hitimes::Error, /\AAttempt to stop an interval that has not started\Z/ )
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
    d.should be_within(0.02).of(0.2)
  end

  it "raises an error if measure is called with no block" do
    lambda{ Hitimes::Interval.measure }.should raise_error( Hitimes::Error, /\ANo block given to Interval.measure\Z/ )
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
    i.start.should be == true
    x = i.start_instant
    i.start_instant.should be > 0
    i.start.should be == false
    x.should == i.start_instant
  end

  it "returns the duration on the first call to stop" do
    i = Hitimes::Interval.now
    d = i.stop
    d.should be_instance_of( Float )
  end

  it "calling stop multiple times on has no effect after the first call" do
    i = Hitimes::Interval.new
    i.start.should be == true
    i.stop

    x = i.stop_instant
    i.stop_instant.should be > 0
    i.stop.should be == false
    x.should == i.stop_instant

  end

  it "duration does not change after stop is calledd" do
    i = Hitimes::Interval.new
    i.start
    x = i.stop
    y = i.duration
    i.stop.should be == false

    z = i.duration

    x.should be == y
    x.should be == z

    y.should be == z
  end

  it "can return how much time has elapsed from the start without stopping the interval" do
    i = Hitimes::Interval.new
    i.start
    x = i.duration_so_far
    i.should be_running
    y = i.duration_so_far
    i.stop
    x.should be < y
    x.should be < i.duration
    y.should be < i.duration
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

