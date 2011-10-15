# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "local_unfuddle_notebook/version"

Gem::Specification.new do |s|
  s.name        = "local_unfuddle_notebook"
  s.version     = LocalUnfuddleNotebook::VERSION
  s.authors     = ["George Mendoza"]
  s.email       = ["gsmendoza@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "local_unfuddle_notebook"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "guard", '~> 0.6.2'
  s.add_development_dependency 'guard-rspec', '~> 0.3.1'
  s.add_development_dependency 'guard-rspec', '~> 0.3.1'
  s.add_development_dependency "rspec", '~> 1.3.2'
  s.add_development_dependency 'ruby-debug', '~> 0.10.4'
  s.add_development_dependency 'webmock', '~> 1.6.2'
  s.add_development_dependency 'vcr', '~> 1.6.0'

  s.add_runtime_dependency "pow", '~> 0.2.3'
  s.add_runtime_dependency "rest-client", '~> 1.6.3'
  s.add_runtime_dependency "slop", '~> 2.1.0'
  s.add_runtime_dependency 'thor', '~> 0.14.6'
  s.add_runtime_dependency "valuable", '~> 0.8.5'
end
