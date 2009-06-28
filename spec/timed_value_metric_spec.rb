require File.expand_path( File.join( File.dirname( __FILE__ ), "spec_helper.rb" ) )

require 'hitimes/timed_value_metric'

describe Hitimes::TimedValueMetric do
  before( :each ) do
    @tm = Hitimes::TimedValueMetric.new( 'test-timed-value-metric' )
  end

  it "knows if it is running or not" do
    @tm.should_not be_running
    @tm.start
    @tm.should be_running
    @tm.stop( 1 )
    @tm.should_not be_running
  end

  it "#split returns the last duration and the timer is still running" do
    @tm.start
    d = @tm.split( 1 )
    @tm.should be_running
    d.should > 0
    @tm.value_stats.count.should == 1
    @tm.timed_stats.count.should == 1
    @tm.duration.should == d
  end

  it "#stop returns false if called more than once in a row" do
    @tm.start
    @tm.stop( 1 ).should > 0
    @tm.stop( 1 ).should == false
  end

  it "does not count a currently running interval as an interval in calculations" do
    @tm.start
    @tm.value_stats.count.should == 0
    @tm.timed_stats.count.should == 0
    @tm.split( 1 )
    @tm.value_stats.count.should == 1
    @tm.timed_stats.count.should == 1
  end

  it "#split called on a stopped timer does nothing" do
    @tm.start
    @tm.stop( 1 )
    @tm.split( 1 ).should == false
  end

  it "calculates the mean of the durations" do
    3.times { |x| @tm.start ; sleep 0.05 ; @tm.stop(x) }
    @tm.timed_stats.mean.should be_close( 0.05, 0.01 )
    @tm.value_stats.mean.should == 1.00
  end

  it "calculates the rate of the counts " do
    5.times { |x| @tm.start ; sleep 0.05 ; @tm.stop( x ) }
    @tm.rate.should be_close( 40.0, 0.2)
  end


  it "calculates the stddev of the durations" do
    3.times { |x| @tm.start ; sleep (0.05 * x) ; @tm.stop(x) }
    @tm.timed_stats.stddev.should be_close( 0.05, 0.001) 
    @tm.value_stats.stddev.should == 1.0
  end

  it "returns 0.0 for stddev if there is no data" do
    @tm.timed_stats.stddev.should == 0.0
    @tm.value_stats.stddev.should == 0.0
  end

  it "keeps track of the min value" do
    3.times { |x| @tm.start ; sleep 0.05 ; @tm.stop( x ) }
    @tm.timed_stats.min.should be_close( 0.05, 0.001 )
    @tm.value_stats.min.should == 0
  end

  it "keeps track of the max value" do
    3.times { |x| @tm.start ; sleep 0.05 ; @tm.stop( x ) }
    @tm.timed_stats.max.should be_close( 0.05, 0.001) 
    @tm.value_stats.max.should == 2
  end

  it "keeps track of the sum value" do
    3.times { |x| @tm.start ; sleep 0.05 ; @tm.stop( x ) }
    @tm.timed_stats.sum.should be_close( 0.15, 0.01 )
    @tm.value_stats.sum.should == 3
  end
  
  it "keeps track of the sum of squares value" do
    3.times { |x| @tm.start ; sleep 0.05 ; @tm.stop( x ) }
    @tm.timed_stats.sumsq.should be_close( 0.0075, 0.0001 )
    @tm.value_stats.sumsq.should == 5
  end

  it "keeps track of the minimum start time of all the intervals" do
    f1 = Time.now.gmtime.to_f * 1000000
    5.times { @tm.start ; sleep 0.05 ; @tm.stop( 1 ) }
    f2 = Time.now.gmtime.to_f * 1000000
    @tm.sampling_start_time.should > f1
    @tm.sampling_start_time.should < f2
    # distance from now to start time should be greater than the distance from
    # the start to the min start_time
    (f2 - @tm.sampling_start_time).should > ( @tm.sampling_start_time - f1 )
  end

  it "keeps track of the last stop time of all the intervals" do
    f1 = Time.now.gmtime.to_f * 1000000
    5.times { @tm.start ; sleep 0.05 ; @tm.stop( 1 ) }
    f2 = Time.now.gmtime.to_f * 1000000
    @tm.sampling_stop_time.should > f1
    @tm.sampling_stop_time.should < f2
    # distance from now to max stop time time should be less than the distance
    # from the start to the max stop time
    (f2 - @tm.sampling_stop_time).should < ( @tm.sampling_stop_time - f1 )
  end

  it "can create an already running timer" do
    t = Hitimes::TimedValueMetric.now( 'already-running' )
    t.should be_running
  end

  it "can measure a block of code from an instance" do
    t = Hitimes::TimedValueMetric.new( 'measure a block' )
    3.times { t.measure( 1 ) { sleep 0.05 } }
    t.duration.should be_close( 0.15, 0.001 )
    t.timed_stats.count.should == 3
    t.value_stats.count.should == 3
  end

  it "returns the value of the block when measuring" do
    t = Hitimes::TimedValueMetric.new( 'measure a block' )
    x = t.measure( 42 ) { sleep 0.05; 42 }
    t.duration.should be_close( 0.05, 0.001 )
    x.should == 42
  end

  describe "#to_hash" do

    it "has name value" do
      h = @tm.to_hash
      h['name'].should == "test-timed-value-metric"
    end

    it "has an empty has for additional_data" do
      h = @tm.to_hash
      h['additional_data'].should == Hash.new
      h['additional_data'].size.should == 0
    end

    it "has a rate" do
      5.times { |x| @tm.start ; sleep 0.05 ; @tm.stop( x ) }
      h = @tm.to_hash
      h['rate'].should be_close( 40.0, 0.3 )
    end

    it "has a unit_count" do
      5.times { |x| @tm.start ; sleep 0.05 ; @tm.stop( x ) }
      h = @tm.to_hash
      h['unit_count'].should ==  10
    end

    fields = %w[ name additional_data sampling_start_time sampling_stop_time value_stats timed_stats rate unit_count ]
    fields.each do |f|
      it "should have a value for #{f}" do
        3.times { |x| @tm.measure(x) { sleep 0.001 } }
        h = @tm.to_hash
        h[f].should_not be_nil
      end
    end
  end 
end
