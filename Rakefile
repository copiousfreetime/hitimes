# vim: syntax=ruby
load 'tasks/this.rb'

This.name     = "hitimes"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{ This.name }"

This.ruby_gemspec do |spec|
  spec.add_development_dependency( 'rake'         , '~> 12.3')
  spec.add_development_dependency( 'minitest'     , '~> 5.5' )
  spec.add_development_dependency( 'rdoc'         , '~> 6.2' )
  spec.add_development_dependency( 'json'         , '~> 2.2' )
  spec.add_development_dependency( 'simplecov'    , '~> 0.17' )

  spec.license = "ISC"
end

load 'tasks/default.rake'
