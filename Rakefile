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


def setup_18
  commands =  [
    'cp Gemfile Gemfile.bak',
    'mv .ruby-version-1.8.7 .ruby-version',
    'cp Gemfile.1.8.7 Gemfile',
    'bundle install --local',
  ]
 
  commands.each{ |c| `#{ c }` }
end

def teardown_18
  commands =  [
    'mv .ruby-version .ruby-version-1.8.7 ',
    'cp Gemfile.bak Gemfile && rm Gemfile.bak',
    'bundle install --local'
  ]

  commands.each{ |c| 
    `#{ c }` 
  }
end


namespace :ruby_18 do
  desc "Switch to 1.8.7"
  task :setup do
    setup_18 if File.exist?('.ruby-version-1.8.7')
    puts 'Using Ruby 1.8.7'
  end

  desc "Teardown to 1.8.7"
  task :teardown do
    teardown_18 unless File.exist?('.ruby-version-1.8.7')
    puts 'Using Ruby 2.1.0'
  end
end
