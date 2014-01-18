# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "zhongwen_tools"
  s.version     = "0.0.3"
  s.authors     = ["Steven Daniels"]
  s.email       = ["steven@tastymantou.com"]
  s.homepage    = ""
  s.summary     = %q{Zhongwen Tools provide romanization conversions and helper methods for Chinese.}
  s.description = %q{Chinese tools for romanization conversions and other helpful string functions for Chinese.}

  s.rubyforge_project = "zhongwen_tools"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('rake', "~> 10.1")
  s.add_development_dependency('pry', "~> 0.9.0")
end
