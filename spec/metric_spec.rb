require "spec_helper"

describe Hitimes::Metric do
  before( :each ) do
    @metric = Hitimes::Metric.new( "testing" )
  end

  it 'has a name' do
    @metric.name.should be == "testing"
  end

  it "has associated data from initialization" do
    m = Hitimes::Metric.new( "more-data", 'foo' => 'bar', 'this' => 'that' )
    m.additional_data['foo'].should be == 'bar'
    m.additional_data['this'].should be == 'that'
    
    m = Hitimes::Metric.new( "more-data", { 'foo' => 'bar', 'this' => 'that' } )
    m.additional_data['foo'].should be == 'bar'
    m.additional_data['this'].should be == 'that'
  end

  it "initially has no sampling times" do
    @metric.sampling_start_time.should be == nil
    @metric.sampling_stop_time.should be == nil
  end
end

 
