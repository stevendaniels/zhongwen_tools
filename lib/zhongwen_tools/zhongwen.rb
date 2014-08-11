# encoding: utf-8
require 'zhongwen_tools/regex'
module ZhongwenTools
  module Zhongwen
    def self.has_zh?(str)
      return false unless str.class == String

      regex = /(#{ ZhongwenTools::Regex.zh }|#{ ZhongwenTools::Regex.zh_punc })/
      !str[regex].nil?
    end

    def self.zh?(str)
      return false unless str.class == String

      regex = /(#{ ZhongwenTools::Regex.zh }+|#{ ZhongwenTools::Regex.zh_punc }+|\s+)/
      str.scan(regex).join == str
    end

    def self.has_zh_punctuation?(str)
      return false unless str.class == String

      !str[ZhongwenTools::Regex.zh_punc].nil?
    end

    def self.strip_zh_punctuation(str)
      str.gsub(ZhongwenTools::Regex.zh_punc, '')
    end
  end
end
