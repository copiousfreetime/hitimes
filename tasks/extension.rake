
# Extensions
#-----------------------------------------------------------------------
require 'pathname'

namespace :ext do
  desc "Build the extension(s)"
  task :build => :clobber do
    with_each_extension do |extension|
      path  = Pathname.new(extension)
      parts = path.split
      conf  = parts.last
      Dir.chdir(path.dirname) do |d|
        ruby conf.to_s
        sh "make"

        mkdir_p ext_dest_dir, :verbose => true
        cp "hitimes_ext.#{RbConfig::CONFIG['DLEXT']}", ext_dest_dir, :verbose => true
      end
    end
  end

  hitimes_jar_file = "lib/hitimes/hitimes.jar"
  if RUBY_PLATFORM == "java" then
    desc "Build the jruby extension"
    task :build_java => [ :clobber, "lib/hitimes/hitimes.jar" ]

    file hitimes_jar_file => FileList["ext/java/src/hitimes/*.java"] do |t|
      jruby_home = RbConfig::CONFIG['prefix']
      jruby_jar  = File.join( jruby_home, 'lib', 'jruby.jar' )

      mkdir_p 'pkg/classes'
      sh "javac -classpath #{jruby_jar} -d pkg/classes #{t.prerequisites.join(' ')}"

      dest_dir = File.dirname(t.name)
      sh "jar cf #{t.name} -C pkg/classes ."
    end
  end
  CLOBBER << hitimes_jar_file

  def ext_dest_dir
    version_sub = RUBY_VERSION.sub(/\.\d$/,'')
    This.project_path( 'lib', 'hitimes', version_sub )
  end

  def with_each_extension
    This.platform_gemspec.extensions.each do |ext|
      yield ext
    end
  end

  def build_win( version = "1.8.7" )
    ext_config = This.platform_gemspec.extensions.frist
    return nil unless ext_config.cross_rbconfig
    rbconfig = ext_config.cross_rbconfig["rbconfig-#{version}"]
    raise ArgumentError, "No cross compiler for version #{version}, we have #{ext_config.cross_rbconfig.keys.join(",")}" unless rbconfig
    with_each_extension do |extension|
      path = Pathname.new(extension)
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
  # ext_config.cross_rbconfig.keys.each do |v|
    # s = v.split("-").last
    # desc "Build the extension for windows version #{s}"
    # win_bname = "build_win-#{s}"
    # win_builds << win_bname
    # task win_bname => :clean do
      # build_win( s )
    # end
  # end

  task :clean do
    with_each_extension do |extension|
      path  = Pathname.new(extension)
      Dir.chdir(path.dirname) do |d|
        if File.exist?( "Makefile" ) then
          sh "make clean"
        end
        rm_f "rbconfig.rb"
      end
    end
  end

  task :clobber do
    with_each_extension do |extension|
      path  = Pathname.new(extension)
      Dir.chdir(path.dirname) do |d|
        if File.exist?( "Makefile" ) then
          sh "make distclean"
        end
        rm_f "rbconfig.rb"
      end
    end
  end
  CLOBBER << FileList["lib/hitimes/1.*/"]
end
task :clobber => 'ext:clobber'
task :clean => 'ext:clean'
task :test => 'ext:build'
