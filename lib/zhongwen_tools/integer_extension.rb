# encoding: utf-8
require 'zhongwen_tools/number'

module ZhongwenTools
  module IntegerExtension

    def to_zh(type = nil)
      #type == :zht ? self.to_zht? : self.to_zhs
         ZhongwenTools::Number.convert(self, type, :i)
    end

    %w(zhs zht).each do |type|
      define_method("to_#{type}") do
         ZhongwenTools::Number.convert(self, type.to_sym, :i)
      end
    end

    def to_pyn
      ZhongwenTools::Number.convert self, :pyn, :i
    end

    # TODO: add to_pyn to_bmpf, to_wg, to_mps2, to_yale, etc.
  end

  # Allow for the use Refinements.
  if RUBY_VERSION >= '2.0.0'
    refine Integer do
      include ::ZhongwenTools::IntegerExtension
    end
  end
end
