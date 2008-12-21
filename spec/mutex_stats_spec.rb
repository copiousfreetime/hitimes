require File.expand_path( File.join( File.dirname( __FILE__ ), "spec_helper.rb" ) )

require 'hitimes_ext'
require 'hitimes/mutexed_stats'

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

  it "is unsafe normally" do
    pending "not for MRI -- not interruptable in this C extension" do
      stats = run_with_scissors( ::Hitimes::Stats.new, @threads, @iters )
      stats.count.should_not == @final_value
    end
  end

  it "has a threadsafe update" do
    stats = run_with_scissors( ::Hitimes::MutexedStats.new, @threads, @iters )
    stats.count.should == @final_value
  end

end
