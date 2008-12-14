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

create_makefile('hitimes_ext')
