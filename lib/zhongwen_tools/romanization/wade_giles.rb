module ZhongwenTools
  module Romanization
    module WadeGiles
      def self.to_wg(*args)
        str, from = args
        from ||= ZhongwenTools::Romanization.romanization?(str)

        ZhongwenTools::Romanization.convert str, :wg, from.to_sym
      end

      def self.wg?(str)
        regex = ZhongwenTools::Romanization.detect_regex(:wg)
        ZhongwenTools::Romanization.detect_romanization(str, regex)
      end

      def self.split(str)
        regex = /(#{ ZhongwenTools::Romanization.detect_regex(:wg) }*)/
        ZhongwenTools::Romanization.split_romanization(str, regex)
      end

      class << self
        [:wade_giles, :wadegiles].each do |m|
          alias_method "to_#{ m }".to_sym, :to_wg
          alias_method "#{ m }?", :wg?
        end
      end
    end
  end
end
