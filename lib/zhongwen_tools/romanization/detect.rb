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
    # There are some situations where wg == pyn, but there's no way to differentiate the two.
    def wg?(str = nil, type = :pyn)
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

    # TODO: zyfh? typy? msp2? yale? wgyrm? romanization?
  end
end
