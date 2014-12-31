module ZhongwenTools
  module Romanization
    module Yale
      def self.to_yale(*args)
        str, from = args
        from ||= ZhongwenTools::Romanization.romanization?(str)

        ZhongwenTools::Romanization.convert str, :yale, from.to_sym
      end

      def self.yale?(str)
        regex = ZhongwenTools::Romanization.detect_regex(:yale)
        ZhongwenTools::Romanization.detect_romanization(str, regex)
      end

      def self.split(str)
        regex = /(#{ ZhongwenTools::Romanization.detect_regex(:yale) }*)/
        ZhongwenTools::Romanization.split_romanization(str, regex)
      end
    end
  end
end
