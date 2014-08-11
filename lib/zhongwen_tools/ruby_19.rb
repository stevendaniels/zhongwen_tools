class String
  def chars
    self.scan(/./mu).to_a
  end
end
