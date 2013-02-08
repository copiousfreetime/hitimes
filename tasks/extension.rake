
# Extensions
#-----------------------------------------------------------------------
require 'pathname'

namespace :ext do

  def mri_extension_dest_dir
    version_sub = RUBY_VERSION.sub(/\.\d$/,'')
    This.project_path( 'lib', 'hitimes', version_sub )
  end

  def mri_extension_basename
    "hitimes_ext.#{RbConfig::CONFIG['DLEXT']}"
  end

  def mri_extension_file
    mri_extension_dest_dir.join( mri_extension_basename )
  end

  def define_mri_extension_tasks
    desc "Build the C extension"
    task :build => mri_extension_file
    file mri_extension_file => This.extension_c_source do
      with_each_extension do |extension|
        path  = Pathname.new(extension)
        parts = path.split
        conf  = parts.last
        Dir.chdir(path.dirname) do |d|
          ruby conf.to_s
          sh "make"

          mkdir_p mri_extension_dest_dir, :verbose => true
          cp mri_extension_basename, mri_extension_dest_dir, :verbose => true
        end
      end
    end
  end

  def hitimes_jar_file
    This.project_path( "lib/hitimes/hitimes.jar" )
  end

  def define_java_extension_tasks
    desc "Build the JAVA extension"
    task :build => hitimes_jar_file
    file hitimes_jar_file => This.extension_java_source do |t|
      jruby_home = Pathname.new( RbConfig::CONFIG['prefix'] )
      jruby_jar  = jruby_home.join( 'lib', 'jruby.jar' )

      mkdir_p 'pkg/classes'
      sh "javac -classpath #{jruby_jar} -d pkg/classes #{t.prerequisites.join(' ')}"

      sh "jar cf #{t.name} -C pkg/classes ."
    end
  end
  CLOBBER << hitimes_jar_file


  if RUBY_PLATFORM == "java" then
    define_java_extension_tasks
  else
    define_mri_extension_tasks
  end

  def with_each_extension
    This.platform_gemspec.extensions.each do |ext|
      yield ext
    end
  end

  def build_win( version = "1.8.7" )
    ext_config = This.platform_gemspec.extensions.first
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
