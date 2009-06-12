require File.expand_path( File.join( File.dirname( __FILE__ ), "spec_helper.rb" ) )

require 'hitimes/metric'

describe Hitimes::Metric do
  before( :each ) do
    @metric = Hitimes::Metric.new( "testing" )
  end

  it 'has a name' do
    @metric.name.should == "testing"
  end

  it "has associated data from initialization" do
    m = Hitimes::Metric.new( "more-data", 'foo' => 'bar', 'this' => 'that' )
    m.additional_data['foo'].should == 'bar'
    m.additional_data['this'].should == 'that'
    
    m = Hitimes::Metric.new( "more-data", { 'foo' => 'bar', 'this' => 'that' } )
    m.additional_data['foo'].should == 'bar'
    m.additional_data['this'].should == 'that'
  end

  it "initially has no sampling times" do
    @metric.sampling_start_time.should == nil
    @metric.sampling_stop_time.should == nil
  end
end

 
