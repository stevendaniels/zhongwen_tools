# encoding: utf-8

module ZhongwenTools
  module Script
    def self.zht?(str)
      str == convert(:zht, str) ||  str == convert(:zhhk, str)
    end

    def self.zhs?(str)
      str == convert(:zhs, str)
    end

    def self.to_zhs(str, type)
      type = type.to_sym
      fail ArgumentError unless [:zhs, :zhcn].include? type

      convert(type, str)
    end

    def self.to_zht(str, type)
      type = type.to_sym
      fail ArgumentError unless [:zht, :zhtw, :zhhk].include? type

      convert(type, str)
    end

    ZH_TYPES = {
      :zht => [0],
      :zhs => [1],
      :zhtw => [2,0],
      :zhhk => [3,0],
      :zhcn => [4,1]
    } unless defined?(ZH_TYPES)

    ZH_CONVERSION_TABLE = [] unless defined?(ZH_CONVERSION_TABLE)


    private
    # Conversion data and algorithm shamelessly stolen from chinese_convt gem.
    # ( https://github.com/xxxooo/chinese_convt )
    #
    # There are two differences:
    #   + Zhongwen Tools loads the conversion data into memory and
    #     chinese_convt reads the file every time it converts. As a result,
    #     Zhongwen Tools is  ~12X faster.
    #   + Zhongwen Tools uses Ruby's nifty str[/regex/] = replacement
    #     instead of indices. Conversion tests using indices fail with Ruby 1.8.
    def self.load_table
      filename = File.expand_path('../script/conversion_data', __FILE__)
      File.open(filename).read.split("\n&\n").each do |group|
        ZH_CONVERSION_TABLE << group.split("\n").map do |type|
          Hash[ type.split(',').map{ |term| term.split(':') } ]
        end
      end

      nil
    end

    def self.convert(type, str)
      load_table if ZH_CONVERSION_TABLE.length == 0
      types = ZH_TYPES[type] || ZH_TYPES[:zht]

      begin
        str_len = str.chars.to_a.size
        n = (str_len < 6)? str_len : 6
        convert_zhongwen(str.dup, str.dup, types, n)

      rescue
        "[#{$!}]"
      end
    end

    def self.convert_zhongwen(str0, str1, types, n)
      ZH_CONVERSION_TABLE.last(n).each do |group|
        types.each do |t|
          group[t].each do |key , value|
            until str0.index(key).nil?
              str0[/#{key}/] = "#" * value.size
              str1[/#{key}/] = value
            end
          end
        end
      end

      str1
    end
  end
end
