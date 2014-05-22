# encoding: utf-8
require 'zhongwen_tools/regex'

module ZhongwenTools
  module Romanization
    extend self
    # Deprecated: a Regex for accurate pinyin. Use ZhongwenTools::Regex.py instead
    PY_REGEX = ZhongwenTools::Regex.py

    # Deprecate: a Regex for accurate pinyin with numbers. use ZhongwenTools::Regex.pyn instead.
    PINYIN_REGEX = ZhongwenTools::Regex.pyn

    # Public: checks if a string is pinyin.
    #         http://en.wikipedia.org/wiki/Pinyin
    #
    # Examples
    #   py?('nǐ hǎo')
    #   # => true
    #
    # Returns Boolean.
    def py?(str = nil)
      str ||= self

      # NOTE: py regex does not include capitals with tones.
      String.downcase(str).gsub(Regex.py, '').strip == ''
    end

    # Public: checks if a string is pinyin.
    #
    # Examples
    #   pyn?('pin1-yin1')
    #   # => true
    #
    # Returns Boolean.
    def pyn?(str = nil)
      str ||= self

      str.gsub(Regex.pyn, '').strip == ''
    end

    # Public: Checks if a String is Zhuyin Fuhao (a.k.a. bopomofo).
    #         http://en.wikipedia.org/wiki/Bopomofo
    #         http://pinyin.info/romanization/bopomofo/index.html
    #
    # str - a String. Optional if the object calling the method is a String.
    #
    # Examples
    #
    #   zyfh?('ㄊㄥ')
    #   # => true
    #
    # Returns a boolean.
    def zyfh?(str = nil)
      str ||= self

      bopomofo = str.gsub(/[1-5\s]/,'')
      bopomofo.scan(Regex.bopomofo).join == bopomofo
    end

    # Public: Checks if a String is a romanization:
    #         Tongyong Pinyin, Wade Giles, MSP2 or Yale.
    #         http://en.wikipedia.org/wiki/Tongyong_Pinyin
    #         http://pinyin.info/romanization/tongyong/
    #         http://en.wikipedia.org/wiki/Wade%E2%80%93Giles
    #
    # str - a String. Optional if the object calling the method is a String.
    #
    # Examples
    #
    #   typy?('chuei niou')
    #   # => true
    #   wg?('Mao2 Tse2 Tung1')
    #
    # Returns a boolean.
    %w(typy wg yale msp2).each do |type|
      define_method("#{type}?") do |str = nil|
        str ||= self
        # TODO: ignore tonal marks from other systems wade giles, tongyong etc.
        s = str.downcase.gsub(/[1-5\s\-']/,'')

        s.scan(detect_regex(type.to_sym)).join == s
      end
    end

    def romanization?(str = nil)
      str ||= self

      [:pyn, :py, :zyfh, :wg, :typy, :yale, :msp2].find do |type|
        self.send("#{type}?", str)
      end
    end

    private

    def detect_regex(type)
      /#{ROMANIZATIONS_TABLE.map{ |r| r[type] || r[:pyn] }.sort{|x,y| x.size <=> y.size}.reverse.join('|')}/
    end
  end
end
