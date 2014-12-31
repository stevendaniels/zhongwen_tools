module ZhongwenTools
  module Romanization
    module MPS2
      def self.to_mps2(*args)
        str, from = args
        from ||= ZhongwenTools::Romanization.romanization?(str)

        ZhongwenTools::Romanization.convert str, :mps2, from.to_sym
      end

      def self.mps2?(str)
        regex = ZhongwenTools::Romanization.detect_regex(:mps2)
        ZhongwenTools::Romanization.detect_romanization(str, regex)
      end

      def self.split(str)
        regex = /(#{ ZhongwenTools::Romanization.detect_regex(:mps2) }*)/
        ZhongwenTools::Romanization.split_romanization(str, regex)
      end
    end
  end
end
