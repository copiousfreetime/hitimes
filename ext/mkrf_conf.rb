require 'rubygems'
require 'mkrf'
require 'rbconfig'

Mkrf::Generator.new('libhitimes') do |g|
    g.logger.level = Logger::WARN

    if g.has_function?( 'clock_gettime' ) then
      g.add_define "USE_INSTANCE_CLOCK_GETTIME"
    elsif Config::CONFIG['host_os'] =~ /darwin/ then
      g.add_define "USE_INSTANCE_OSX"
      g.additional_code  = "LIBS.concat(' -framework CoreServices')"
    end

end
