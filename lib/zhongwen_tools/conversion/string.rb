#encoding: utf-8

module ZhongwenTools
  module String
    include ZhongwenTools::Conversion

    def zht?(str = nil)
      str ||= self

      str == convert(:zht, str) ||  str == convert(:zhhk, str)
    end

    def zhs?(str = nil)
      str ||= self

      str == convert(:zhs, str)
    end
  end
end
