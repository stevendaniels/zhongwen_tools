module ZhongwenTools
  module Romanization
    module TongyongPinyin
      def self.to_typy(*args)
        str, from = args
        from ||= ZhongwenTools::Romanization.romanization?(str)

        ZhongwenTools::Romanization.convert str, :typy, from.to_sym
      end

      def self.typy?(str)
        regex = ZhongwenTools::Romanization.detect_regex(:typy)
        ZhongwenTools::Romanization.detect_romanization(str, regex)
      end

      def self.split(str)
        regex = /(#{ ZhongwenTools::Romanization.detect_regex(:typy) }*)/
        ZhongwenTools::Romanization.split_romanization(str, regex)
      end

      class << self
        [:tongyong, :tongyong_pinyin].each do |m|
          alias_method "to_#{ m }".to_sym, :to_typy
          alias_method "#{ m }?", :typy?
        end
      end
    end
  end
end
