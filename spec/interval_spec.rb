require "spec_helper"

describe Hitimes::Interval do
  it "raises an error if duration is called on a non-started interval" do
    i = Hitimes::Interval.new
    _(lambda{ i.duration }).must_raise( Hitimes::Error, /\AAttempt to report a duration on an interval that has not started\Z/ )
  end

  it "raises an error if stop is called on a non-started interval" do
    i = Hitimes::Interval.new
    _(lambda { i.stop }).must_raise( Hitimes::Error, /\AAttempt to stop an interval that has not started\Z/ )
  end

  it "knows if it has been started" do
    i = Hitimes::Interval.new
    _(i.started?).must_equal false

    i.start
    _(i.started?).must_equal true
  end

  it "knows if it has been stopped" do
    i = Hitimes::Interval.new
    i.start
    _(i.stopped?).must_equal false
    i.stop
    _(i.stopped?).must_equal true
  end

  it "knows if it is currently running" do
    i = Hitimes::Interval.new
    _(i.running?).must_equal false
    i.start
    _(i.running?).must_equal true
    i.stop
    _(i.running?).must_equal false
  end

  it "can time a block of code" do
    d = Hitimes::Interval.measure do
      sleep 0.2
    end
    _(d).must_be_close_to(0.2, 0.002)
  end

  it "raises an error if measure is called with no block" do
    _(lambda{ Hitimes::Interval.measure }).must_raise( Hitimes::Error, /\ANo block given to Interval.measure\Z/ )
  end

  it "creates an interval via #now" do
    i = Hitimes::Interval.now
    _(i.started?).must_equal true
    _(i.stopped?).must_equal false
  end

  it "calling duration multiple times returns successivly grater durations" do
    i = Hitimes::Interval.new
    i.start
    y = i.duration
    z = i.duration
    _(z).must_be :>, y
  end

  it "calling start multiple times on has no effect after the first call" do
    i = Hitimes::Interval.new
    _(i.start).must_equal true
    x = i.start_instant
    _(i.start_instant).must_be :>, 0
    _(i.start).must_equal false
    _(x).must_equal i.start_instant
  end

  it "returns the duration on the first call to stop" do
    i = Hitimes::Interval.now
    d = i.stop
    _(d).must_be_instance_of( Float )
  end

  it "calling stop multiple times on has no effect after the first call" do
    i = Hitimes::Interval.new
    _(i.start).must_equal true
    i.stop

    x = i.stop_instant
    _(i.stop_instant).must_be :>, 0
    _(i.stop).must_equal false
    _(x).must_equal i.stop_instant

  end

  it "duration does not change after stop is calledd" do
    i = Hitimes::Interval.new
    i.start
    x = i.stop
    y = i.duration
    _(i.stop).must_equal false

    z = i.duration

    _(x).must_equal y
    _(x).must_equal z

    _(y).must_equal z
  end

  it "can return how much time has elapsed from the start without stopping the interval" do
    i = Hitimes::Interval.new
    i.start
    x = i.duration_so_far
    _(i.running?).must_equal true
    y = i.duration_so_far
    i.stop
    _(x).must_be :<, y
    _(x).must_be :<, i.duration
    _(y).must_be :<, i.duration
  end

  describe "#split" do

    it "creates a new Interval object" do
      i = Hitimes::Interval.new
      i.start
      i2 = i.split
      _(i.object_id).wont_equal i2.object_id
    end

    it "with the stop instant equivialent to the previous Interval's start instant" do
      i = Hitimes::Interval.new
      i.start
      i2 = i.split
      _(i.stop_instant).must_equal i2.start_instant
    end
  end

end

