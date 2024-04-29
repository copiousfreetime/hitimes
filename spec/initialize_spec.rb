# frozen_string_literal: true

require "spec_helper"

describe "Hitimes::Initialize" do
  it "should return a clock id" do
    val = Hitimes::Initialize.determine_clock_id
    _(val).wont_be_nil
  end

  it "should return :CLOCK_REALTIME as a last option" do
    val = Hitimes::Initialize.determine_clock_id([:CLOCK_REALTIME])
    _(val).must_equal(Process::CLOCK_REALTIME)
  end

  it "should raise an error if no clock id is found" do
    _(lambda {
        Hitimes::Initialize.determine_clock_id([])
      }).must_raise(Hitimes::Error, /Unable to find a high resolution clock/)
  end
end
