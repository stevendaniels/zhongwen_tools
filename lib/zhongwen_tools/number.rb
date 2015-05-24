# encoding: utf-8
require 'zhongwen_tools/regex'
require 'zhongwen_tools/zhongwen'
require 'zhongwen_tools/romanization/pinyin'
require 'zhongwen_tools/number/number_table'

module ZhongwenTools
  # Number.to_pyn, to_i, to_zhs, etc.
  module Number
    def self.number?(obj)
      case obj
      when String
        regex = /([\d]|#{ZhongwenTools::Regex.zh_numbers}){1,}/
        "#{obj}".gsub(regex, '') == ''
      when Integer, Fixnum, Float
        true
      end
    end

    %w(i zhs zht pyn).each do |action|
      define_singleton_method("to_#{ action }") do |*args|
        obj, from, separator = args
        from ||= number_type(obj)

        convert(obj, action.to_sym, from.to_sym, separator)
      end
    end

    def self.to_zh(obj, type = :zhs, from = nil)
      case type.to_sym
      when :zht
        to_zht(obj, from)
      else
        to_zhs(obj, from)
      end
    end

    private

    def self.convert(obj, to, from, separator = '')
      fail ArgumentError unless [:zhs, :zht, :i, :pyn].include?(to.to_sym)
      fail ArgumentError unless [String, Integer, Fixnum, Bignum].include?(obj.class)

      number =   convert_from from, to, obj

      if to == :i
        combine_integers(number)
      elsif to == :pyn
        regex = /#{ %w(yi4 wan4 qian1 bai2 shi2).map { |x| 'ling2\-' + x }.join('|')}/
        finalize_number(number, '-').gsub(regex, '').gsub(/\-+/, '-').gsub(/\-$/, '')
      else
        finalize_number(number)
      end
    end

    def self.number_type(obj)
      klass = obj.class

      if [Fixnum, Integer, Bignum].include?(klass)
        :i
      else
        if ZhongwenTools::Zhongwen.zh?(obj)
          if zht?(obj)
            :zht
          else
            :zhs
          end
        else # assume it is pyn
          # FIXME: might need to convert to pyn
          :pyn
        end
      end
    end

    def self.zht?(str)
      str[/#{ZhongwenTools::Regex.zht_numbers }*/] == str
    end

    def self.zhs?(str)
      !zht?(str)
    end

    def self.convert_from(from, to, number)
      if from == :zht
        convert_from_zh(to, number)
      elsif from == :zhs
        convert_from_zh(to, number)
      elsif from == :i
        convert_from_integer(to, number)
      elsif from == :pyn
        convert_from_pyn(to, number)
      end
    end

    def self.convert_from_pyn(to, pyn)
      # convert to pyn
      # split the pyn and then
      pyns = ZhongwenTools::Romanization::Pinyin.split_pyn(pyn)

      pyns.map do |p|
        convert_number(p).fetch(to) { p }
      end
    end

    def self.convert_from_zh(to, number)
      converted_number = number.chars.map do |zh|
        convert_number(zh).fetch(to) { zh }
      end

      converted_number
    end

    def self.combine_integers(integers)
      return combine_year(integers) if year?(integers)

      number = 0
      length = integers.size
      skipped = false

      integers.each_with_index do |curr_num, i|
        next if skipped == i

        if (i + 2) <= length
          number, i = combine_integer(integers, number, curr_num, i)
          skipped = i + 1
        else
          number = adjust_integer(number, curr_num)
        end
      end

      number
    end

    def self.year?(integers)
      integers.select { |i| i < 10 }.size == integers.size
    end

    def self.combine_year(integers)
      integers.map(&:to_s).join.to_i
    end

    def self.combine_integer(integers, result, curr_num, i)
      next_number = integers[i + 1]
      result += next_number * curr_num if number_multiplier?(next_number)

      [result, i]
    end

    def self.adjust_integer(number, curr_num)
      number_multiplier?(curr_num) ? number * curr_num : number + curr_num
    end

    def self.number_multiplier?(number)
      [10, 100, 1_000, 10_000, 100_000_000].include? number
    end

    def self.convert_from_integer(to, int)
      # FIXME: this will fail for numbers over 1 billion.
      result = []
      nums = convert_integer_to_reversed_array_of_integers(int)

      nums.each_with_index do |num, i|
        wan =  wan_level(wan, i)

        if i == 0
          result << convert_integer(num, to) unless num == 0
        else
          if i < 5
            result << convert_wan_level(i, to)
          elsif i == 8
            result << convert_wan_level(i, to)
          else
            result << "#{ convert_wan_level(i - (i / 4 * 4), to) }#{ convert_wan_level((i / 4 * 4), to) }"
          end
          # checks the wan level and ...
          result << convert_integer(num, to) if wan_ok?(num, wan, i)
        end
      end

      result.reverse!
    end

    def self.convert_integer_to_reversed_array_of_integers(int)
      int.to_s.chars.to_a.reverse.map(&:to_i)
    end

    def self.wan_ok?(num, wan, i)
      (num == 1 && (10**(i) / 10_000**wan) != 10) || num != 1
    end

    def self.wan_level(wan, i)
      wan ||= 0
      wan += 1 if (i + 1) % 5 == 0

      wan
    end

    def self.convert_wan_level(i, to)
      convert_integer((10**(i)), to) || convert_integer((10**(i) / 10_000), to) || convert_integer((10**(i) / 10_000**2), to)
    end

    def self.convert_integer(int, to)
      NUMBERS_TABLE.find { |x| x[:i] == int }.fetch(to) { 0 }
    end

    def self.convert_number(number)
      NUMBERS_TABLE.find { |x|  x[:zhs] == number || x[:zht] == number || x[:pyn] == number }
    end

    def self.finalize_number(number, separator = '')
      # FIXME: is finalize_number the best name you can think of?
      # NOTE: Figuring out usage of "liang" vs. "er" is pretty
      #       difficult, so always use "er" instead.
      number.join(separator).gsub(/零[#{ Regex.zh_number_multiple }]*/u, '')
    end
  end
end
