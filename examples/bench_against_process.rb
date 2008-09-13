require 'benchmark'
require 'time'
require 'hitimes_interval'

include Benchmark

bm(20) do |x|
  x.report("Process")   { 100_000.times { Process.times } }
  x.report("Interval")  { 100_000.times { i = HiTimes::Interval.new ;  i.start! ; i.stop! }  }
end
