# frozen_string_literal: true

if RUBY_VERSION >= "1.9.2"
  require "simplecov"
  puts "Using coverage!"
  SimpleCov.start if ENV["COVERAGE"]
end

require "hitimes"
require "minitest/autorun"
require "minitest/focus"
require "minitest/pride"
