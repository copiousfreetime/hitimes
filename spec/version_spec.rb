require File.expand_path( File.join( File.dirname( __FILE__ ), "spec_helper" ) )

describe "Hitimes::Version" do
    it "should have a major numbers that is >= 0" do
        Hitimes::Version::MAJOR.should >= 0
    end 

    it "should have a minor number that is >= 0" do
        Hitimes::Version::MINOR.should >= 0
    end 

    it "should have a tiny number that is >= 0" do
        Hitimes::Version::BUILD.should >= 0
    end 

    it "should have an array representation" do
        Hitimes::Version.to_a.should have(3).items
    end 

    it "should have a string representation" do
        Hitimes::Version.to_s.should match(/\d+\.\d+\.\d+/)
    end 

    it "should be accessable as a constant" do
        Hitimes::VERSION.should match(/\d+\.\d+\.\d+/)
    end 
end
