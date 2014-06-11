# encoding: utf-8
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
      # FIXME: ignore punctuation
      str.scan(/(#{Regex.pyn})/).map{ |arr| arr[0].strip.gsub('-','') }.flatten
    end

    def split_zyfh(str = nil)
      str ||= self

      str.scan(/([#{Regex.bopomofo}]*)/).map{ |arr| arr[0].strip.gsub('-','') }.flatten - ['']
    end

    %w(typy wg yale mps2).each do |type|
      define_method("split_#{type}") do |str = nil|
        str ||= self
        # TODO: ignore tonal marks from other systems wade giles, tongyong etc.
        str.scan(/(#{detect_regex(type.to_sym)}*)/).map{ |arr| arr[0].strip.gsub('-','') }.flatten - ['']
      end
    end
  end
end
