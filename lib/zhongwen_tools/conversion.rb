#encoding: utf-8

module ZhongwenTools

  module Conversion
    extend self

    def to_zhs(str = nil)
      str ||= self

      convert(:zhs, str)
    end

    def to_zht(str = nil)
      str ||= self

      convert(:zht, str)
    end

    def to_zhtw(str = nil)
      str ||= self


      convert(:zhtw, str)
    end

    def to_zhhk(str = nil)
      str ||= self

      convert(:zhhk, str)
    end

    def to_zhcn(str = nil)
      str ||= self

      convert(:zhcn, str)
    end

    ZH_TYPES = {
      :zht => [0],
      :zhs => [1],
      :zhtw => [2,0],
      :zhhk => [3,0],
      :zhcn => [4,1]
    }

    ZH_CONVERSION_TABLE = []

    private
    # Conversion data and algorithm shamelessly stolen from chinese_convt gem.
    # There are two differences:
    #   + Zhongwen Tools loads the conversion data into memory and
    #     chinese_convt reads the file every time. As a result, 
    #     Zhongwen Tools is  ~12X faster.
    #   + Zhongwen Tools uses Ruby's nifty str[/regex/] = replacement
    #     instead of indices. Conversion tests using indices fail with Ruby 1.8.
    # ( https://github.com/xxxooo/chinese_convt )
    def load_table
      filename = File.expand_path('../conversion/conversion_data', __FILE__)
      File.open(filename).read.split("\n&\n").each do |group|
      ZH_CONVERSION_TABLE << group.split("\n").map do |type|
          Hash[ type.split(',').map{ |term| term.split(':') } ]
        end
      end

      nil
    end

    def convert(type, str)
      load_table if ZH_CONVERSION_TABLE.length == 0
      arr = ZH_TYPES[type] || ZH_TYPES[:zht]

      begin
        str0 = str.dup
        str1 = str.dup
        str_len = ZhongwenTools::String.size(str)
        n = ( str_len < 6)? str_len : 6
        ZH_CONVERSION_TABLE.last(n).each do |group|
          arr.each do |t|
            group[t].each do |key , value|
              while !! q = str0.index( key )
                str0[/#{key}/] = "#" * value.size
                str1[/#{key}/] = value
              end
            end
          end
        end

        str1

      rescue
        "[#{$!}]"
      end
    end
  end
end

require File.expand_path("../conversion/string", __FILE__)
