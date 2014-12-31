module ZhongwenTools
  module Romanization
    module ZhuyinFuhao
      def self.to_bpmf(*args)
        str, from = args
        from ||= ZhongwenTools::Romanization.romanization?(str)

        ZhongwenTools::Romanization.convert str, :bpmf, from.to_sym
      end

      def self.bpmf?(str)
        regex = ZhongwenTools::Regex.bopomofo

        ZhongwenTools::Romanization.detect_romanization(str, regex)
      end

      def self.split(str)
        regex = /([#{ZhongwenTools::Regex.bopomofo}]*)/

        ZhongwenTools::Romanization.split_romanization(str, regex)
      end

      class << self
        [:zhuyin_fuhao, :zhuyinfuhao, :zyfh, :zhyfh, :bopomofo].each do |m|
          alias_method "to_#{ m }".to_sym, :to_bpmf
          alias_method "#{ m }?", :bpmf?
        end
      end
    end
  end
end
