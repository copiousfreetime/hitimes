# DO NOT EDIT - This file is automatically generated
# Make changes to Manifest.txt and/or Rakefile and regenerate
# -*- encoding: utf-8 -*-
# stub: hitimes 2.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "hitimes".freeze
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jeremy Hinegardner".freeze]
  s.date = "2022-04-17"
  s.description = "A fast, high resolution timer library for recording peformance metrics. * (http://github.com/copiousfreetime/hitimes) * (http://github.com/copiousfreetime/hitimes) * email jeremy at copiousfreetime dot org * `git clone url git://github.com/copiousfreetime/hitimes.git`".freeze
  s.email = "jeremy@copiousfreetime.org".freeze
  s.extra_rdoc_files = ["CONTRIBUTING.md".freeze, "HISTORY.md".freeze, "Manifest.txt".freeze, "README.md".freeze]
  s.files = ["CONTRIBUTING.md".freeze, "HISTORY.md".freeze, "LICENSE".freeze, "Manifest.txt".freeze, "README.md".freeze, "Rakefile".freeze, "examples/benchmarks.rb".freeze, "examples/stats.rb".freeze, "lib/hitimes.rb".freeze, "lib/hitimes/initialize.rb".freeze, "lib/hitimes/instant.rb".freeze, "lib/hitimes/interval.rb".freeze, "lib/hitimes/metric.rb".freeze, "lib/hitimes/mutexed_stats.rb".freeze, "lib/hitimes/paths.rb".freeze, "lib/hitimes/stats.rb".freeze, "lib/hitimes/timed_metric.rb".freeze, "lib/hitimes/timed_value_metric.rb".freeze, "lib/hitimes/value_metric.rb".freeze, "lib/hitimes/version.rb".freeze, "spec/hitimes_spec.rb".freeze, "spec/interval_spec.rb".freeze, "spec/metric_spec.rb".freeze, "spec/mutex_stats_spec.rb".freeze, "spec/paths_spec.rb".freeze, "spec/spec_helper.rb".freeze, "spec/stats_spec.rb".freeze, "spec/timed_metric_spec.rb".freeze, "spec/timed_value_metric_spec.rb".freeze, "spec/value_metric_spec.rb".freeze, "spec/version_spec.rb".freeze, "tasks/default.rake".freeze, "tasks/this.rb".freeze]
  s.homepage = "http://github.com/copiousfreetime/hitimes".freeze
  s.licenses = ["ISC".freeze]
  s.rdoc_options = ["--main".freeze, "README.md".freeze, "--markup".freeze, "tomdoc".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.2".freeze)
  s.rubygems_version = "3.1.6".freeze
  s.summary = "A fast, high resolution timer library for recording peformance metrics.".freeze
  s.test_files = ["spec/hitimes_spec.rb".freeze, "spec/interval_spec.rb".freeze, "spec/metric_spec.rb".freeze, "spec/mutex_stats_spec.rb".freeze, "spec/paths_spec.rb".freeze, "spec/spec_helper.rb".freeze, "spec/stats_spec.rb".freeze, "spec/timed_metric_spec.rb".freeze, "spec/timed_value_metric_spec.rb".freeze, "spec/value_metric_spec.rb".freeze, "spec/version_spec.rb".freeze]

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rake>.freeze, ["~> 12.3"])
    s.add_development_dependency(%q<minitest>.freeze, ["~> 5.5"])
    s.add_development_dependency(%q<minitest-focus>.freeze, ["~> 1.3"])
    s.add_development_dependency(%q<rdoc>.freeze, ["~> 6.2"])
    s.add_development_dependency(%q<json>.freeze, ["~> 2.2"])
    s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.17"])
  else
    s.add_dependency(%q<rake>.freeze, ["~> 12.3"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.5"])
    s.add_dependency(%q<minitest-focus>.freeze, ["~> 1.3"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 6.2"])
    s.add_dependency(%q<json>.freeze, ["~> 2.2"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.17"])
  end
end
