require 'spec_helper'

describe Hitimes::MutexedStats do
  before( :each ) do
    @threads = 5
    @iters   = 10_000
    @final_value = @threads * @iters
  end

  def run_with_scissors( stats, threads, iters )
    spool = []
    threads.times do |t|
      spool << Thread.new { iters.times{ stats.update( 1 ) } }
    end
    spool.each { |t| t.join }
    return stats
  end

  it "Hitimes::Stats is threadsafe" do
    stats = run_with_scissors( ::Hitimes::Stats.new, @threads, @iters )
    _(stats.count).must_equal @final_value
  end

  it "has a threadsafe update" do
    stats = run_with_scissors( ::Hitimes::MutexedStats.new, @threads, @iters )
    _(stats.count).must_equal @final_value
  end

end
