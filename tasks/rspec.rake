
require 'tasks/config'

#--------------------------------------------------------------------------------
# configuration for running rspec.  This shows up as the test:default task
#--------------------------------------------------------------------------------
if spec_config = Configuration.for_if_exist?("test") then
  if spec_config.mode == "spec" then
    namespace :test do

      task :default => :spec

      require 'spec/rake/spectask'
      Spec::Rake::SpecTask.new do |r| 
        r.ruby_opts   = spec_config.ruby_opts
        r.libs        = [ Hitimes::Paths.lib_path, 
                          Hitimes::Paths.root_dir ]
        r.spec_files  = spec_config.files 
        r.spec_opts   = spec_config.options

        if rcov_config = Configuration.for_if_exist?('rcov') then
          r.rcov      = true
          r.rcov_dir  = rcov_config.output_dir
          r.rcov_opts = rcov_config.rcov_opts
        end
      end

      pre_req = "ext:build"
      pre_req += "_java" if RUBY_PLATFORM == "java"
      task :spec => pre_req
    end
  end
end
