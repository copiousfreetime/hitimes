require 'spec_helper'

describe Hitimes::TimedMetric do
  before( :each ) do
    @tm = Hitimes::TimedMetric.new( 'test-timed-metric' )
  end

  it "knows if it is running or not" do
    _(@tm.running?).must_equal false
    @tm.start
    _(@tm.running?).must_equal true
    @tm.stop
    _(@tm.running?).must_equal false
  end

  it "#split returns the last duration and the timer is still running" do
    @tm.start
    d = @tm.split
    _(@tm.running?).must_equal true
    _(d).must_be :>, 0
    _(@tm.count).must_equal 1
    _(@tm.duration).must_equal d
  end

  it "#stop returns false if called more than once in a row" do
    @tm.start
    _(@tm.stop).must_be :>, 0
    _(@tm.stop).must_equal false
  end

  it "does not count a currently running interval as an interval in calculations" do
    @tm.start
    _(@tm.count).must_equal 0
    @tm.split
    _(@tm.count).must_equal 1
  end

  it "#split called on a stopped timer does nothing" do
    @tm.start
    @tm.stop
    _(@tm.split).must_equal false
  end

  it "calculates the mean of the durations" do
    2.times { @tm.start ; sleep 0.05 ; @tm.stop }
    _(@tm.mean).must_be_close_to(0.05, 0.002)
  end

  it "calculates the rate of the counts " do
    5.times { @tm.start ; sleep 0.05 ; @tm.stop }
    _(@tm.rate).must_be_close_to(20.00, 0.5)
  end


  it "calculates the stddev of the durations" do
    3.times { |x| @tm.start ; sleep(0.05 * x) ; @tm.stop }
    _(@tm.stddev).must_be_close_to(0.05)
  end

  it "returns 0.0 for stddev if there is no data" do
    _(@tm.stddev).must_equal 0.0
  end

  it "keeps track of the min value" do
    2.times { @tm.start ; sleep 0.05 ; @tm.stop }
    _(@tm.min).must_be_close_to(0.05, 0.01)
  end

  it "keeps track of the max value" do
    2.times { @tm.start ; sleep 0.05 ; @tm.stop }
    _(@tm.max).must_be_close_to(0.05, 0.01)
  end

  it "keeps track of the sum value" do
    2.times { @tm.start ; sleep 0.05 ; @tm.stop }
    _(@tm.sum).must_be_close_to(0.10, 0.01)
  end

  it "keeps track of the sum of squars value" do
    3.times { @tm.start ; sleep 0.05 ; @tm.stop }
    _(@tm.sumsq).must_be_close_to(0.0075)
  end

  it "keeps track of the minimum start time of all the intervals" do
    f1 = Time.now.gmtime.to_f * 1_000_000
    5.times { @tm.start ; sleep 0.05 ; @tm.stop }
    f2 = Time.now.gmtime.to_f * 1_000_000
    _(@tm.sampling_start_time).must_be :>=, f1
    _(@tm.sampling_start_time).must_be :<, f2
    # distance from now to start time should be greater than the distance from
    # the start to the min start_time
    _((f2 - @tm.sampling_start_time)).must_be :>, ( @tm.sampling_start_time - f1 )
  end

  it "keeps track of the last stop time of all the intervals" do
    f1 = Time.now.gmtime.to_f * 1_000_000
    sleep 0.01
    5.times { @tm.start ; sleep 0.05 ; @tm.stop }
    sleep 0.01
    f2 = Time.now.gmtime.to_f * 1_000_000
    _(@tm.sampling_stop_time).must_be :>, f1
    _(@tm.sampling_stop_time).must_be :<=, f2
    # distance from now to max stop time time should be less than the distance
    # from the start to the max stop time
    _((f2 - @tm.sampling_stop_time)).must_be :<, ( @tm.sampling_stop_time - f1 )
  end

  it "can create an already running timer" do
    t = Hitimes::TimedMetric.now( 'already-running' )
    _(t.running?).must_equal true
  end

  it "can measure a block of code from an instance" do
    t = Hitimes::TimedMetric.new( 'measure a block' )
    3.times { t.measure { sleep 0.05 } }
    _(t.duration).must_be_close_to(0.15, 0.01)
    _(t.count).must_equal 3
  end

  it "returns the value of the block when measuring" do
    t = Hitimes::TimedMetric.new( 'measure a block' )
    x = t.measure { sleep 0.05; 42 }
    _(t.duration).must_be_close_to(0.05, 0.002)
    _(x).must_equal 42
  end

  describe "#to_hash" do

    it "has name value" do
      h = @tm.to_hash
      _(h['name']).must_equal "test-timed-metric"
    end

    it "has an empty hash for additional_data" do
      h = @tm.to_hash
      _(h['additional_data']).must_equal Hash.new
      _(h['additional_data'].size).must_equal 0
    end

    it "has the right sum" do
      10.times { |x| @tm.measure { sleep 0.01*x  } }
      h = @tm.to_hash
      _(h['sum']).must_be_close_to(0.45, 0.01)
    end

    fields = ::Hitimes::Stats::STATS.dup + %w[ name additional_data sampling_start_time sampling_stop_time ]
    fields.each do |f|
      it "has a value for #{f}" do
        @tm.measure { sleep 0.001 }
        h = @tm.to_hash
        _(h[f]).wont_be_nil
      end
    end
  end 
end
