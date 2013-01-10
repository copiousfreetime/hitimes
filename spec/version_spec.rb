require "spec_helper"

describe "Hitimes::Version" do
  it "should be accessable as a constant" do
    Hitimes::VERSION.should match(/\d+\.\d+\.\d+/)
  end
end
