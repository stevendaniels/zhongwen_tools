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

require 'test/unit'

if RUBY_VERSION < '1.9'
  class Test::Unit::TestCase
    def refute(statement, message = '')
      assert !statement, message
    end
  end
end
