# vim: syntax=ruby
load 'tasks/this.rb'

This.name     = "hitimes"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{ This.name }"

This.ruby_gemspec do |spec|
  spec.add_development_dependency( 'rake'         , '~> 10.4')
  spec.add_development_dependency( 'minitest'     , '~> 5.5' )
  spec.add_development_dependency( 'rdoc'         , '~> 4.2'  )
  spec.add_development_dependency( 'json'         , '~> 1.8' )
  spec.add_development_dependency( 'rake-compiler', '~> 0.9' )
  spec.add_development_dependency( 'simplecov'    , '~> 0.9' )

  spec.extensions.concat This.extension_conf_files
  spec.license = "ISC"
end

This.java_gemspec( This.ruby_gemspec ) do |spec|
  spec.extensions.clear
  spec.files << "lib/hitimes/hitimes.jar"
end

load 'tasks/default.rake'
load 'tasks/extension.rake'
