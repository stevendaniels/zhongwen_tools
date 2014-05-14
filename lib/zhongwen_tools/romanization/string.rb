#encoding: utf-8
module ZhongwenTools
  module Romanization

    # Public: splits pinyin number strings.
    #
    # str - a String to be split
    #
    # Examples
    #
    #
    #   split_pyn('zhong1guo2')
    #   # => ['zhong1', 'guo2']
    #
    # Returns an Array of Strings.
    def split_pyn(str = nil)
      str ||= self
      puts "WARNING: string is not valid pinyin-num format. #{str}" unless str.pyn?

      str.scan(/(#{PINYIN_REGEX})/).map{ |arr| arr[0].strip.gsub('-','') }.flatten
    end
  end
end
