require File.expand_path( File.join( File.dirname( __FILE__ ), "spec_helper.rb" ) )

require 'hitimes/timed_metric'

describe Hitimes::TimedMetric do
  before( :each ) do
    @tm = Hitimes::TimedMetric.new( 'test-timed-metric' )
  end

  it "knows if it is running or not" do
    @tm.should_not be_running
    @tm.start
    @tm.should be_running
    @tm.stop
    @tm.should_not be_running
  end

  it "#split returns the last duration and the timer is still running" do
    @tm.start
    d = @tm.split
    @tm.should be_running
    d.should > 0
    @tm.count.should == 1
    @tm.duration.should == d
  end

  it "#stop returns false if called more than once in a row" do
    @tm.start
    @tm.stop.should > 0
    @tm.stop.should == false
  end

  it "does not count a currently running interval as an interval in calculations" do
    @tm.start
    @tm.count.should == 0
    @tm.split
    @tm.count.should == 1
  end

  it "#split called on a stopped timer does nothing" do
    @tm.start
    @tm.stop
    @tm.split.should == false
  end

  it "calculates the mean of the durations" do
    2.times { @tm.start ; sleep 0.05 ; @tm.stop }
    @tm.mean.should > 0.04
  end

  it "calculates the rate of the counts " do
    5.times { @tm.start ; sleep 0.05 ; @tm.stop }
    @tm.rate.should > 19.0
  end


  it "calculates the stddev of the durations" do
    2.times { @tm.start ; sleep 0.05 ; @tm.stop }
    @tm.stddev.should > 0.0
  end

  it "returns 0.0 for stddev if there is no data" do
    @tm.stddev.should == 0.0
  end


  it "keeps track of the min value" do
    2.times { @tm.start ; sleep 0.05 ; @tm.stop }
    @tm.min.should > 0
  end

  it "keeps track of the max value" do
    2.times { @tm.start ; sleep 0.05 ; @tm.stop }
    @tm.max.should > 0
  end

  it "keeps track of the minimum start time of all the intervals" do
    f1 = Time.now.gmtime.to_f * 1000000
    5.times { @tm.start ; sleep 0.05 ; @tm.stop }
    f2 = Time.now.gmtime.to_f * 1000000
    @tm.sampling_start_time.should > f1
    @tm.sampling_start_time.should < f2
    # distance from now to start time should be greater than the distance from
    # the start to the min start_time
    (f2 - @tm.sampling_start_time).should > ( @tm.sampling_start_time - f1 )
  end

  it "keeps track of the last stop time of all the intervals" do
    f1 = Time.now.gmtime.to_f * 1000000
    5.times { @tm.start ; sleep 0.05 ; @tm.stop }
    f2 = Time.now.gmtime.to_f * 1000000
    @tm.sampling_stop_time.should > f1
    @tm.sampling_stop_time.should < f2
    # distance from now to max stop time time should be less than the distance
    # from the start to the max stop time
    (f2 - @tm.sampling_stop_time).should < ( @tm.sampling_stop_time - f1 )
  end

  it "can create an already running timer" do
    t = Hitimes::TimedMetric.now( 'already-running' )
    t.should be_running
  end

  it "can measure a block of code from an instance" do
    t = Hitimes::TimedMetric.new( 'measure a block' )
    3.times { t.measure { sleep 0.05 } }
    t.duration.should > 0.14
    t.count.should == 3
  end

  it "returns the value of the block when measuring" do
    t = Hitimes::TimedMetric.new( 'measure a block' )
    x = t.measure { sleep 0.05; 42 }
    t.duration.should > 0.0
    x.should == 42
  end



end
