require File.expand_path( File.join( File.dirname( __FILE__ ), "spec_helper.rb" ) )

require 'hitimes/timer'

describe Hitimes::Timer do

  it "knows if it is running or not" do
    t = Hitimes::Timer.new
    t.should_not be_running
    t.start
    t.should be_running
    t.stop
    t.should_not be_running
  end

  it "#split returns the last duration and the timer is still running" do
    t = Hitimes::Timer.now
    d = t.split
    t.should be_running
    d.should > 0
    t.count.should == 1
    t.duration.should == d
  end

  it "#stop returns false if called more than once in a row" do
    t = Hitimes::Timer.new
    t.start
    t.stop.should > 0
    t.stop.should == false
  end

  it "does not count a currently running interval as an interval in calculations" do
    t = Hitimes::Timer.new
    t.start
    t.count.should == 0
    t.split
    t.count.should == 1
  end

  it "#split called on a stopped timer does nothing" do
    t = Hitimes::Timer.new
    t.start
    t.stop
    t.split.should == false
  end

  it "calculates the mean of the durations" do
    t = Hitimes::Timer.new
    2.times { t.start ; sleep 0.05 ; t.stop }
    t.mean.should > 0.04
  end

  it "calculates the rate of the counts " do
    t = Hitimes::Timer.new
    5.times { t.start ; sleep 0.05 ; t.stop }
    t.rate.should > 19.0
  end


  it "calculates the stddev of the durations" do
    t = Hitimes::Timer.new
    2.times { t.start ; sleep 0.05 ; t.stop }
    t.stddev.should > 0.0
  end

  it "returns 0.0 for stddev if there is no data" do
    t = Hitimes::Timer.new
    t.stddev.should == 0.0
  end

  it "retuns 0.0 for mean if there is no data" do
    Hitimes::Timer.new.mean.should == 0.0
  end

  it "keeps track of the min value" do
    t = Hitimes::Timer.new
    2.times { t.start ; sleep 0.05 ; t.stop }
    t.min.should > 0
  end

  it "keeps track of the max value" do
    t = Hitimes::Timer.new
    2.times { t.start ; sleep 0.05 ; t.stop }
    t.max.should > 0
  end

  it "can create an already running timer" do
    t = Hitimes::Timer.now
    t.should be_running
  end

  it "can measure a block of code's execution time" do
    dur = Hitimes::Timer.measure { sleep 0.05 }
    dur.should > 0.025
  end

  it "can measuer a block of code from an instance" do
    t = Hitimes::Timer.new
    3.times { t.measure { sleep 0.05 } }
    t.duration.should > 0.14
    t.count.should == 3
  end

end

