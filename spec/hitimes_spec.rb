# frozen_string_literal: true

require "spec_helper"

describe Hitimes do
  it "can time a block of code" do
    d = Hitimes.measure { sleep 0.01 }
    _(d).must_be :>, 0
  end

  it "raises an error if measure is called with no block" do
    _(-> { Hitimes.measure }).must_raise(Hitimes::Error)
  end

  it "has the raw instant value" do
    v = Hitimes.raw_instant
    _(v).must_be :>, 0
  end

  it "has access to the number of nanosecond" do
    f = Hitimes::NANOSECONDS_PER_SECOND
    _(f).must_be :>, 0
  end
end
