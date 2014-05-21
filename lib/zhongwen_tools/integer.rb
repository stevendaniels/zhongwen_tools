# encoding: utf-8
require File.expand_path("../numbers", __FILE__)

module ZhongwenTools
  module Integer
    include ZhongwenTools::Numbers
    extend self

    def to_zh(type = nil)
      type == :zht ? self.to_zht? : self.to_zhs
    end

    def to_zhs(int = nil)
      int ||= self
      number_to_zhs :num, int.to_s
    end

    def to_zht(int = nil)
      int ||= self
      number_to_zht :num, int.to_s
    end

    def to_pyn(int = nil)
      int ||= self
      number_to_pyn int.to_s, :num
    end
  end
end
