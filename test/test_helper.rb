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
