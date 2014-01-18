require 'bundler/gem_tasks'
require 'rake/testtask'
Bundler.require :test

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test
