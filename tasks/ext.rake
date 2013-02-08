require 'rake/extensiontask'

Rake::ExtensionTask.new( This.name ) do |ext|
  ext.ext_dir   = File.join( 'ext', This.name ) 
  ext.lib_dir   = File.join( 'lib', This.name )
  ext.gem_spec  = This.ruby_gemspec
  
  ext.cross_compile = true                # enable cross compilation (requires cross compile toolchain)
  ext.cross_platform = 'i386-mswin32'     # forces the Windows platform instead of the default one
                                          # configure options only for cross compile
end
task :test_requirements => :compile
