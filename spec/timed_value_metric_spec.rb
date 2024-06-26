# frozen_string_literal: true

require "spec_helper"

describe Hitimes::TimedValueMetric do
  before(:each) do
    @tm = Hitimes::TimedValueMetric.new("test-timed-value-metric")
  end

  it "knows if it is running or not" do
    _(@tm.running?).must_equal false
    @tm.start
    _(@tm.running?).must_equal true
    @tm.stop(1)
    _(@tm.running?).must_equal false
  end

  it "#split returns the last duration and the timer is still running" do
    @tm.start
    d = @tm.split(1)
    _(@tm.running?).must_equal true
    _(d).must_be :>, 0
    _(@tm.value_stats.count).must_equal 1
    _(@tm.timed_stats.count).must_equal 1
    _(@tm.duration).must_equal d
  end

  it "#stop returns false if called more than once in a row" do
    @tm.start
    _(@tm.stop(1)).must_be :>, 0
    _(@tm.stop(1)).must_equal false
  end

  it "does not count a currently running interval as an interval in calculations" do
    @tm.start
    _(@tm.value_stats.count).must_equal 0
    _(@tm.timed_stats.count).must_equal 0
    @tm.split(1)
    _(@tm.value_stats.count).must_equal 1
    _(@tm.timed_stats.count).must_equal 1
  end

  it "#split called on a stopped timer does nothing" do
    @tm.start
    @tm.stop(1)
    _(@tm.split(1)).must_equal false
  end

  it "calculates the mean of the durations" do
    3.times do |x|
      @tm.start
      @tm.stop(x)
    end
    _(@tm.timed_stats.mean).must_be :>, 0
    _(@tm.value_stats.mean).must_equal 1.00
  end

  it "calculates the rate of the counts " do
    5.times do |x|
      @tm.start
      @tm.stop(x)
    end
    _(@tm.rate).must_be :>, 0
  end

  it "calculates the stddev of the durations" do
    3.times do |x|
      @tm.start
      @tm.stop(x)
    end
    _(@tm.timed_stats.stddev).must_be :>, 0
    _(@tm.value_stats.stddev).must_equal 1.0
  end

  it "returns 0.0 for stddev if there is no data" do
    _(@tm.timed_stats.stddev).must_equal 0.0
    _(@tm.value_stats.stddev).must_equal 0.0
  end

  it "keeps track of the min value" do
    3.times do |x|
      @tm.start
      @tm.stop(x)
    end
    _(@tm.timed_stats.min).must_be :>, 0
    _(@tm.value_stats.min).must_equal 0
  end

  it "keeps track of the max value" do
    3.times do |x|
      @tm.start
      @tm.stop(x)
    end
    _(@tm.timed_stats.max).must_be :>, 0
    _(@tm.value_stats.max).must_equal 2
  end

  it "keeps track of the sum value" do
    3.times do |x|
      @tm.start
      @tm.stop(x)
    end
    _(@tm.timed_stats.sum).must_be :>, 0
    _(@tm.value_stats.sum).must_equal 3
  end

  it "keeps track of the sum of squares value" do
    3.times do |x|
      @tm.start
      @tm.stop(x)
    end
    _(@tm.timed_stats.sumsq).must_be :>, 0
    _(@tm.value_stats.sumsq).must_equal 5
  end

  it "keeps track of the minimum start time of all the intervals" do
    f1 = Time.now.gmtime.to_f * 1_000_000
    5.times do
      @tm.start
      @tm.stop(1)
    end
    f2 = Time.now.gmtime.to_f * 1_000_000
    _(@tm.sampling_start_time).must_be :>=, f1
    _(@tm.sampling_start_time).must_be :<, f2
  end

  it "keeps track of the last stop time of all the intervals" do
    f1 = Time.now.gmtime.to_f * 1_000_000
    5.times do
      @tm.start
      @tm.stop(1)
    end
    f2 = Time.now.gmtime.to_f * 1_000_000
    _(@tm.sampling_stop_time).must_be :>, f1
    _(@tm.sampling_stop_time).must_be :<=, f2
  end

  it "can create an already running timer" do
    t = Hitimes::TimedValueMetric.now("already-running")
    _(t.running?).must_equal true
  end

  it "can measure a block of code from an instance" do
    t = Hitimes::TimedValueMetric.new("measure a block")
    3.times { t.measure(1) { sleep 0.001 } }
    _(t.duration).must_be :>, 0
    _(t.timed_stats.count).must_equal 3
    _(t.value_stats.count).must_equal 3
  end

  it "returns the value of the block when measuring" do
    t = Hitimes::TimedValueMetric.new("measure a block")
    x = t.measure(42) do
      sleep 0.001
      42
    end
    _(t.duration).must_be :>, 0
    _(x).must_equal 42
  end

  describe "#to_hash" do
    it "has name value" do
      h = @tm.to_hash
      _(h["name"]).must_equal "test-timed-value-metric"
    end

    it "has an empty has for additional_data" do
      h = @tm.to_hash
      _(h["additional_data"]).must_equal({})
      _(h["additional_data"].size).must_equal 0
    end

    it "has a rate" do
      5.times do |x|
        @tm.start
        @tm.stop(x)
      end
      h = @tm.to_hash
      _(h["rate"]).must_be :>, 0
    end

    it "has a unit_count" do
      5.times do |x|
        @tm.start
        @tm.stop(x)
      end
      h = @tm.to_hash
      _(h["unit_count"]).must_equal 10
    end

    fields = %w[name additional_data sampling_start_time sampling_stop_time value_stats timed_stats rate unit_count]
    fields.each do |f|
      it "has a value for #{f}" do
        3.times { |x| @tm.measure(x) { sleep 0.001 } }
        h = @tm.to_hash
        _(h[f]).wont_be_nil
      end
    end
  end
end
