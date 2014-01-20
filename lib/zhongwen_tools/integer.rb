#encoding: utf-8
require './lib/zhongwen_tools/numbers'

module ZhongwenTools
  module Integer
    include ZhongwenTools::Numbers

    def to_zh(type = nil)
      type == :zht ? self.to_zht? : self.to_zhs
    end

    def to_zhs(int = nil)
      int ||= self
      convert_number_to_simplified :num, int.to_s
    end

    def to_zht(int = nil)
      int ||= self
      convert_number_to_traditional :num, int.to_s
    end

    def to_pyn(int = nil)
      int ||= self
      convert_number_to_pyn int.to_s, :num
    end

    class Basement
      include ZhongwenTools::Integer
    end

    def self.to_zhs(*args)
      Basement.new.to_zhs(*args)
    end
    def self.to_zht(*args)
      Basement.new.to_zht(*args)
    end
    def self.to_pyn(*args)
      Basement.new.to_pyn(*args)
    end
  end
end
