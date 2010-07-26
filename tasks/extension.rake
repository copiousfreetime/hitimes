require 'tasks/config'
require 'pathname'

#-----------------------------------------------------------------------
# Extensions
#-----------------------------------------------------------------------

if ext_config = Configuration.for_if_exist?('extension') then
  namespace :ext do  
    desc "Build the extension(s)"
    task :build => :clean do
      ext_config.configs.each do |extension|
        path  = Pathname.new(extension)
        parts = path.split
        conf  = parts.last
        Dir.chdir(path.dirname) do |d| 
          ruby conf.to_s
          sh "make" 

          # install into requireable location so specs will run
          subdir = "hitimes/#{RUBY_VERSION.sub(/\.\d$/,'')}"
          dest_dir = Hitimes::Paths.lib_path( subdir )
          mkdir_p dest_dir, :verbose => true
          cp "hitimes_ext.#{Config::CONFIG['DLEXT']}", dest_dir, :verbose => true
        end
      end
    end 

    desc "Build the jruby extension"
    task :build_jruby => :clean do
      path = "ext/java"
      Dir.chdir( path ) do |d|
        #java_ext = "lib/hitimes/java/#{RUBY_VERSION.sub(/\.\d$/,'')}/hitimes_ext.#{Config::CONFIG['DLEXT']}"
        java_ext = "lib/hitimes/hitimes.jar"
        jruby_home = Config::CONFIG['prefix']
        classpath = "#{jruby_home}/lib/jruby.jar"
        FileUtils.mkdir_p "../../#{File.dirname( java_ext )}"
        sh "javac -g -cp #{classpath} hitimes/*.java"
        sh "jar cf ../../#{java_ext} hitimes/*.class"
      end
    end


    def build_win( version = "1.8.6" )
      ext_config = Configuration.for("extension")
      rbconfig = ext_config.cross_rbconfig["rbconfig-#{version}"]
      raise ArgumentError, "No cross compiler for version #{version}, we have #{ext_config.cross_rbconfig.keys.join(",")}" unless rbconfig
      Hitimes::GEM_SPEC.extensions.each do |extension|
        path = Pathname.new(extension)
        parts = path.split
        conf = parts.last
        rvm = File.expand_path( "~/.rvm/bin/rvm" )
        Dir.chdir(path.dirname) do |d| 
          if File.exist?( "Makefile" ) then
            sh "make clean distclean"
          end
          cp "#{rbconfig}", "rbconfig.rb"
          rubylib = ENV['RUBYLIB']
          ENV['RUBYLIB'] = "."
          sh %[#{rvm} #{version} -S extconf.rb]
          ENV['RUBYLIB'] = rubylib
          sh "make"
        end
      end
    end

    win_builds = []
    ext_config.cross_rbconfig.keys.each do |v|
      s = v.split("-").last
      desc "Build the extension for windows version #{s}"
      win_bname = "build_win-#{s}"
      win_builds << win_bname
      task win_bname => :clean do
        build_win( s )
      end
    end

    task :clean do
      ext_config.configs.each do |extension|
        path  = Pathname.new(extension)
        parts = path.split
        conf  = parts.last
        Dir.chdir(path.dirname) do |d| 
          if File.exist?( "Makefile" ) then
            sh "make clean"
          end
          rm_f "rbconfig.rb"
        end 
      end 
    end 

    task :clobber do
      ext_config.configs.each do |extension|
        path  = Pathname.new(extension)
        parts = path.split
        conf  = parts.last
        Dir.chdir(path.dirname) do |d| 
          if File.exist?( "Makefile" ) then
            sh "make distclean"
          end
          rm_f "rbconfig.rb"
        end 
      end 
    end
  end
end
