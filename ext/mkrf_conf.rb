require 'rubygems'
require 'mkrf'
require 'rbconfig'

Mkrf::Generator.new('hitimes_ext') do |g|
    g.logger.level = Logger::WARN

    if Config::CONFIG['host_os'] =~ /darwin/ then
      g.add_define "USE_INSTANT_OSX=1"
      g.additional_code  = "LIBS.concat(' -framework CoreServices')"
    elsif Config::CONFIG['host_os'] =~ /win32/ then
      g.add_define "USE_INSTANT_WINDOWS=1"
    else
      g.include_library("rt")
      if g.has_function?( 'clock_gettime' ) then
        g.add_define "USE_INSTANT_CLOCK_GETTIME=1"
      end
    end

end
