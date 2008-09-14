require 'benchmark'
require 'time'

#
# this is all here in case this example is run from the examples directory
#
begin
  require 'hitimes'
rescue LoadError => le
  ext_path = File.expand_path( File.join( File.dirname( __FILE__ ), "..", "ext" ) )
  lib_path = File.expand_path( File.join( File.dirname( __FILE__ ), "..", "lib" ) )
  if $:.include?( ext_path ) then
    raise le
  end
  $: << ext_path
  $: << lib_path
  retry
end

#----------------------------------------------------------------------
# test program to look at the performance sampling time durations using
# different methods
#----------------------------------------------------------------------

include Benchmark

#
# return a duration using hitimes
#
def hitimes_duration_i1
  i = Hitimes::Interval.new
  i.start
  i.stop
end

def hitimes_duration_i2
  Hitimes::Interval.now.stop
end

def hitimes_duration_t
  Hitimes::Timer.now.stop
end

#
# use the Struct::Tms values and return  the difference in User time between 2 
# successive calls
#
def process_duration
  t1 = Process.times.utime
  Process.times.utime - t1
end

#
# Take 2 times and subtract one from the other
#
def time_duration
  t1 = Time.now.to_f
  Time.now.to_f - t1
end
  

#
bm(20) do |x|
  x.report("Process")              { 100_000.times { process_duration } }
  x.report("Time")                 { 100_000.times { time_duration    } }
  x.report("Hitimes::Timer")       { 100_000.times { hitimes_duration_t } }
  x.report("Hitimes::Interval 1")  { 100_000.times { hitimes_duration_i1 } }
  x.report("Hitimes::Interval 2")  { 100_000.times { hitimes_duration_i2 } }
end
