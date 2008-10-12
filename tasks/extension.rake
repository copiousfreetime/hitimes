require 'tasks/config'
require 'pathname'

#-----------------------------------------------------------------------
# Extensions
#-----------------------------------------------------------------------

if ext_config = Configuration.for_if_exist?('extension') then
  namespace :ext do  
    desc "Build the extension(s)"
    task :build do
      Hitimes::GEM_SPEC.extensions.each do |extension|
        path = Pathname.new(extension)
        parts = path.split
        conf = parts.last
        Dir.chdir(path.dirname) do |d| 
          ruby conf.to_s
          #sh "rake default"
          sh "make" 
        end
      end
    end 

    desc "Build the extension for windows"
    task :build_win => :clobber do
      Hitimes::GEM_SPEC.extensions.each do |extension|
        path = Pathname.new(extension)
        parts = path.split
        conf = parts.last
        Dir.chdir(path.dirname) do |d| 
          cp "rbconfig-mingw.rb", "rbconfig.rb"
          sh "ruby -I. extconf.rb"
          sh "make"
        end
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
