# frozen_string_literal: true

begin
  require "debug"
rescue LoadError => _e
end

require "hitimes"
require "minitest/focus"
require "minitest/pride"
