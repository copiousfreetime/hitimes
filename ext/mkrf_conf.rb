require 'rubygems'
require 'mkrf'
require 'rbconfig'

Mkrf::Generator.new('interval') do |g|
    g.logger.level = Logger::WARN

    if g.has_function?( 'clock_gettime' ) then
      g.add_define "USE_INSTANT_CLOCK_GETTIME=1"
    elsif Config::CONFIG['host_os'] =~ /darwin/ then
      g.add_define "USE_INSTANT_OSX=1"
      g.additional_code  = "LIBS.concat(' -framework CoreServices')"
    elsif g.has_function?( 'QueryPerformanceCounter' ) then
      g.add_define "USE_INSTANT_WINDOWS=1"
    end

end
