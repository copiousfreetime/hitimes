if RUBY_VERSION >= '1.9.2' then
  require 'simplecov'
  puts "Using coverage!"
  SimpleCov.start if ENV['COVERAGE']
end

require 'rspec/autorun'
require 'hitimes'

