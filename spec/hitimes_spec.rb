require 'spec_helper'

describe Hitimes do
  it "can time a block of code" do
    d = Hitimes.measure do
      sleep 0.2
    end
    d.should be_within(0.02).of(0.2)
  end

  it "raises an error if measure is called with no block" do
    lambda{ Hitimes.measure }.should raise_error( Hitimes::Error, /\ANo block given to Interval.measure\Z/ )
  end
end
