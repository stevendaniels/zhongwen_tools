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
require 'minitest/autorun'
#require 'test/unit'

if RUBY_VERSION < '1.9'
  class Minitest::Test
    def refute(statement, message = '')
      assert !statement, message
    end

    def skip
      return
    end
  end
end
