require "spec_helper"

describe "Hitimes::Version" do
  it "should be accessable as a constant" do
    _(Hitimes::VERSION).must_match(/\d+\.\d+\.\d+/)
  end
end
