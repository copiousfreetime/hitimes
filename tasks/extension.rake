require 'tasks/config'
require 'pathname'

#-----------------------------------------------------------------------
# Extensions
#-----------------------------------------------------------------------

if ext_config = Configuration.for_if_exist?('extension') then
  namespace :ext do  
    desc "Build the extension(s)"
    task :build => :clobber do
      Hitimes::GEM_SPEC.extensions.each do |extension|
        path = Pathname.new(extension)
        parts = path.split
        conf = parts.last
        Dir.chdir(path.dirname) do |d| 
          ruby conf.to_s
          sh "make" 
        end
      end
    end 

    def build_win( version = "1.8.6" )
      ext_config = Configuration.for("extension")
      rbconfig = ext_config.cross_rbconfig["rbconfig-#{version}"]
      raise ArgumentError, "No cross compiler for version #{version}, we have #{ext_config.cross_rbconfig.keys.join(",")}" unless rbconfig
      ruby_exe = if version =~ /1\.8/ then
                   "ruby"
                 else
                   "ruby1.9"
                 end
      Hitimes::GEM_SPEC.extensions.each do |extension|
        path = Pathname.new(extension)
        parts = path.split
        conf = parts.last
        Dir.chdir(path.dirname) do |d| 
          cp "#{rbconfig}", "rbconfig.rb"
          sh "#{ruby_exe} -I. extconf.rb"
          sh "make"
        end
      end
    end

    ext_config.cross_rbconfig.keys.each do |v|
      s = v.split("-").last
      desc "Build the extension for windows version #{s}"
      task "build_win-#{s}"  => :clobber do
        build_win( s )
      end
    end

    task :clean do
      ext_config.configs.each do |extension|
        path  = Pathname.new(extension)
        parts = path.split
        conf  = parts.last
        Dir.chdir(path.dirname) do |d| 
          #sh "rake clean"
          sh "make clean"
        end 
      end 
    end 

    task :clobber do
      ext_config.configs.each do |extension|
        path  = Pathname.new(extension)
        parts = path.split
        conf  = parts.last
        Dir.chdir(path.dirname) do |d| 
          #sh "rake clobber"
          if File.exist?( "Makefile" ) then
            sh "make distclean"
          end
        end 
      end 
    end
  end
end
