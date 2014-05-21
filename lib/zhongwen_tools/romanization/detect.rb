# encoding: utf-8
require File.expand_path("../../regex", __FILE__)

module ZhongwenTools
  module Romanization
    # Deprecated: a Regex for accurate pinyin. Use ZhongwenTools::Regex.py instead
    PY_REGEX = ZhongwenTools::Regex.py

    # Deprecate: a Regex for accurate pinyin with numbers. use ZhongwenTools::Regex.pyn instead.
    PINYIN_REGEX = ZhongwenTools::Regex.pyn

    # Public: checks if a string is pinyin.
    #
    # Examples
    #   py?('nǐ hǎo')
    #   # => true
    #
    # Returns Boolean.
    def py?(str = nil)
      str ||= self

      str.gsub(ZhongwenTools::Regex.py, '').strip == ''
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

      str.gsub(ZhongwenTools::Regex.pyn, '').strip == ''
    end

    # Public: Checks if a string is wade-giles.
    #
    # Examples
    #   wg?('pin1-yin1')
    #   # => false
    #
    # Returns a Boolean.
    def wg?(str = nil, type = :pyn)
      # NOTE: There are some situations where wg == pyn, but there's no way to differentiate the two.
      # FIXME: it shouldn't be pyn, but it should be able to conver to pyn
      #        Actually, wade-giles does sometimes overlap with pyn. So this
      #        method creates false negatives. A future :romanization method
      #        would default to pyn, but this method shouldn't.
      #        Add tests where str.pyn? and str.wg?

      str ||= self
      wg = ZhongwenTools::Romanization.to_wade_giles(str, type)
      # TODO: need to convert string to pyn.
      pyn = str
      wg != pyn && wg.gsub(/[1-5]/,'')
    end

    # Public: Checks if a String is Zhuyin Fuhao (a.k.a. bopomofo).
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
      bopomofo.scan(ZhongwenTools::Regex.bopomofo).join == bopomofo
    end

    # Public: Checks if a String is Tongyong Pinyin.
    #         http://en.wikipedia.org/wiki/Tongyong_Pinyin
    #         http://pinyin.info/romanization/tongyong/
    #
    # str - a String. Optional if the object calling the method is a String.
    #
    # Examples
    #
    #   typy?('chuei niou')
    #   # => true
    #
    # Returns a boolean.
    def typy?(str = nil)
      str ||= self

      typy = str.gsub(/[1-5\s\-']/,'')
      # Sorting by String length means it will match the longest possible part.
      # FIXME: it is probably possible for this to have false negatives. 
      #        A more comprehensive regex like Regex.pyn would be needed
      #        to accurately detect typy.
      regex_str = ROMANIZATIONS_TABLE.map{ |r| r[:typy] || r[:py] }.sort{|x,y| x.size <=> y.size}.reverse.join('|')
      typy.scan(/#{regex_str}/).join == typy
    end

    # TODO: msp2? yale? wgyrm? romanization?
  end
end
