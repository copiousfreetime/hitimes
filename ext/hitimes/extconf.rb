require 'rbconfig'
require 'mkmf'

if Config::CONFIG['host_os'] =~ /darwin/ then
  $CFLAGS += " -DUSE_INSTANT_OSX=1 -Wall"
  $LDFLAGS += " -framework CoreServices"
elsif Config::CONFIG['host_os'] =~ /win32/ or Config::CONFIG['host_os'] =~ /mingw/ then
  $CFLAGS += " -DUSE_INSTANT_WINDOWS=1"
else
  if have_library("rt", "clock_gettime") then
    $CFLAGS += " -DUSE_INSTANT_CLOCK_GETTIME=1"
  end
end

# put in a different location if on windows so we can have fat binaries
parent_dir = "hitimes"
if RUBY_PLATFORM =~ /(mswin|mingw)/i then
  v = RUBY_VERSION.gsub(/\.\d$/,'')
  parent_dir = File.join( parent_dir, v )
end
create_makefile("#{parent_dir}/hitimes_ext")
