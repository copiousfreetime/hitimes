require File.expand_path( File.join( File.dirname( __FILE__ ), "spec_helper" ) )

describe "Hitimes::Version" do
  it "should be accessable as a constant" do
    Hitimes::VERSION.should match(/\d+\.\d+\.\d+/)
  end
end
