
require 'tasks/config'

#--------------------------------------------------------------------------------
# configuration for running rspec.  This shows up as the test:default task
#--------------------------------------------------------------------------------
if spec_config = Configuration.for_if_exist?("test") then
  if spec_config.mode == "spec" then
    namespace :test do

      task :default => :spec

      require 'rspec/core/rake_task'
      RSpec::Core::RakeTask.new do |t|
        t.ruby_opts  = spec_config.ruby_opts
        t.rspec_opts = spec_config.options

        if rcov_config = Configuration.for_if_exist?('rcov') then
          #t.rcov      = true
          #t.rcov_dir  = rcov_config.output_dir
          ##t.rcov_opts = rcov_config.rcov_opts
        end
      end

      pre_req = "ext:build"
      pre_req += "_java" if RUBY_PLATFORM == "java"
      task :spec => pre_req
    end
  end
end
