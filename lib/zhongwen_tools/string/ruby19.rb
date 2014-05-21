# encoding: utf-8
class String
  define_method(:chars) do
    self.scan(/./mu).to_a
  end
end
