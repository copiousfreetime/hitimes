# vim: syntax=ruby
load 'tasks/this.rb'

This.name     = "hitimes"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{ This.name }"

This.ruby_gemspec do |spec|
  spec.add_development_dependency( 'rake'         , '~> 13.0')
  spec.add_development_dependency( 'minitest'     , '~> 5.5' )
  spec.add_development_dependency( 'minitest-junit' , '~> 1.0' )
  spec.add_development_dependency( 'minitest-focus', '~> 1.3' )
  spec.add_development_dependency( 'rdoc'         , '~> 6.4' )
  spec.add_development_dependency( 'json'         , '~> 2.2' )
  spec.add_development_dependency( 'simplecov'    , '~> 0.21' )

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/copiousfreetime/htauth/issues",
    "changelog_uri"   => "https://github.com/copiousfreetime/htauth/blob/master/HISTORY.md",
    "homepage_uri"    => "https://github.com/copiousfreetime/htauth",
    "source_code_uri" => "https://github.com/copiousfreetime/htauth",
  }

  spec.license = "ISC"
end

load 'tasks/default.rake'
