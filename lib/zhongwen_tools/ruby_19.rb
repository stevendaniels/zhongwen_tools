# encoding: utf-8
class String
  def chars
    self.force_encoding('utf-8').scan(/./mu).to_a
  end
end
