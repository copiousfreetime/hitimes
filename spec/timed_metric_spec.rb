require 'spec_helper'

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
    d.should be > 0
    @tm.count.should be == 1
    @tm.duration.should be == d
  end

  it "#stop returns false if called more than once in a row" do
    @tm.start
    @tm.stop.should be > 0
    @tm.stop.should be == false
  end

  it "does not count a currently running interval as an interval in calculations" do
    @tm.start
    @tm.count.should be == 0
    @tm.split
    @tm.count.should be == 1
  end

  it "#split called on a stopped timer does nothing" do
    @tm.start
    @tm.stop
    @tm.split.should be == false
  end

  it "calculates the mean of the durations" do
    2.times { @tm.start ; sleep 0.05 ; @tm.stop }
    @tm.mean.should be_within(0.01).of(0.05)
  end

  it "calculates the rate of the counts " do
    5.times { @tm.start ; sleep 0.05 ; @tm.stop }
    @tm.rate.should be_within(1.0).of(20.00)
  end


  it "calculates the stddev of the durations" do
    3.times { |x| @tm.start ; sleep(0.05 * x) ; @tm.stop }
    @tm.stddev.should be_within(0.002).of( 0.05)
  end

  it "returns 0.0 for stddev if there is no data" do
    @tm.stddev.should be == 0.0
  end

  it "keeps track of the min value" do
    2.times { @tm.start ; sleep 0.05 ; @tm.stop }
    @tm.min.should be_within( 0.002 ).of(0.05)
  end

  it "keeps track of the max value" do
    2.times { @tm.start ; sleep 0.05 ; @tm.stop }
    @tm.max.should be_within( 0.002 ).of(0.05)
  end

  it "keeps track of the sum value" do
    2.times { @tm.start ; sleep 0.05 ; @tm.stop }
    @tm.sum.should be_within( 0.005 ).of(0.10)
  end

  it "keeps track of the sum of squars value" do
    3.times { @tm.start ; sleep 0.05 ; @tm.stop }
    @tm.sumsq.should be_within(0.001).of(0.0075)
  end

  it "keeps track of the minimum start time of all the intervals" do
    f1 = Time.now.gmtime.to_f * 1_000_000
    5.times { @tm.start ; sleep 0.05 ; @tm.stop }
    f2 = Time.now.gmtime.to_f * 1_000_000
    @tm.sampling_start_time.should be >= f1
    @tm.sampling_start_time.should be < f2
    # distance from now to start time should be greater than the distance from
    # the start to the min start_time
    (f2 - @tm.sampling_start_time).should > ( @tm.sampling_start_time - f1 )
  end

  it "keeps track of the last stop time of all the intervals" do
    f1 = Time.now.gmtime.to_f * 1_000_000
    sleep 0.01
    5.times { @tm.start ; sleep 0.05 ; @tm.stop }
    sleep 0.01
    f2 = Time.now.gmtime.to_f * 1_000_000
    @tm.sampling_stop_time.should be > f1
    @tm.sampling_stop_time.should be <= f2
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
    t.duration.should be_within(0.01).of(0.15)
    t.count.should be == 3
  end

  it "returns the value of the block when measuring" do
    t = Hitimes::TimedMetric.new( 'measure a block' )
    x = t.measure { sleep 0.05; 42 }
    t.duration.should be_within(0.002).of(0.05)
    x.should be == 42
  end

  describe "#to_hash" do

    it "has name value" do
      h = @tm.to_hash
      h['name'].should be == "test-timed-metric"
    end

    it "has an empty hash for additional_data" do
      h = @tm.to_hash
      h['additional_data'].should be == Hash.new
      h['additional_data'].size.should be == 0
    end

    it "has the right sum" do
      10.times { |x| @tm.measure { sleep 0.01*x  } }
      h = @tm.to_hash
      h['sum'].should be_within( 0.01).of(0.45)
    end

    fields = ::Hitimes::Stats::STATS.dup + %w[ name additional_data sampling_start_time sampling_stop_time ]
    fields.each do |f|
      it "should have a value for #{f}" do
        @tm.measure { sleep 0.001 }
        h = @tm.to_hash
        h[f].should_not be_nil
      end
    end
  end 
end
