require 'rubygems' if RUBY_VERSION < '1.9'
require 'bundler/gem_tasks'
require 'rake/testtask'
Bundler.require :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
end

desc "Run tests"
task :default => :test
