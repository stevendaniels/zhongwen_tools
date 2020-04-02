# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'zhongwen_tools/version'

Gem::Specification.new do |s|
  s.name        = 'zhongwen_tools'
  s.license     = 'MIT'
  s.version     = ZhongwenTools::VERSION
  s.authors     = ['Steven Daniels']
  s.email       = ['steven@tastymantou.com']
  s.homepage    = 'https://github.com/stevendaniels/zhongwen_tools'
  s.summary     = %q{Zhongwen Tools provide romanization conversions and helper methods for Chinese.}
  s.description = %q{Chinese tools for romanization conversions and other helpful string functions for Chinese.}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency "rake", ">= 12.3.3"
  if RUBY_VERSION >= '1.9'
    s.add_development_dependency('simplecov', '~> 0.16', '>= 0.16.0')
    s.add_development_dependency('simplecov-gem-adapter', '~> 1.0', '>= 1.0.1')
    s.add_development_dependency('coveralls', '~> 0.8', '>= 0.8.1')
    s.add_development_dependency('minitest', '~> 5.5', '>= 5.5.1')
    s.add_development_dependency('pry', '~> 0.10', '>= 0.10.1')
    s.add_development_dependency('minitest-reporters', '~> 1.0', '>= 1.0.10')
  end

  if RUBY_VERSION >= '2.1'
    s.add_development_dependency('memory_profiler', '0.0.4')
  end
end
