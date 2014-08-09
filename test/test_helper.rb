begin
  require 'coveralls'
  Coveralls.wear!
rescue LoadError
  puts 'Coverage disabled.'
end

begin
  require 'pry'
rescue LoadError
  puts 'Pry disabled'
end

gem 'minitest'
gem 'minitest-reporters'

require 'minitest/autorun'
require "minitest/reporters"

Minitest::Reporters.use!  [Minitest::Reporters::SpecReporter.new]
