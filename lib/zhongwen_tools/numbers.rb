#encoding: utf-8
module ZhongwenTools
  module Numbers

    NUMBER_MULTIPLES = '拾十百佰千仟仟万萬亿億'

    NUMBERS_TABLE = [
      { :zhs => '零', :zht => '零', :num => 0, :pyn => 'ling2'},
      { :zhs => '〇', :zht => '〇', :num => 0, :pyn => 'ling2'},
      { :zhs => '一', :zht => '一', :num => 1, :pyn => 'yi1'},
      { :zhs => '壹', :zht => '壹', :num => 1, :pyn => 'yi1'},
      { :zhs => '幺', :zht => '幺', :num => 1, :pyn => 'yao1'},
      { :zhs => '二', :zht => '二', :num => 2, :pyn => 'er4'},
      { :zhs => '两', :zht => '兩', :num => 2, :pyn => 'liang3'},
      { :zhs => '贰', :zht => '貳', :num => 2, :pyn => 'er4'},
      { :zhs => '三', :zht => '三', :num => 3, :pyn => 'san1'},
      { :zhs => '弎', :zht => '弎', :num => 3, :pyn => 'san1'},
      { :zhs => '叁', :zht => '參', :num => 3, :pyn => 'san1'},
      { :zhs => '四', :zht => '四', :num => 4, :pyn => 'si4'},
      { :zhs => '䦉', :zht => '䦉', :num => 4, :pyn => 'si4'},
      { :zhs => '肆', :zht => '肆', :num => 4, :pyn => 'si4'},
      { :zhs => '五', :zht => '五', :num => 5, :pyn => 'wu3'},
      { :zhs => '伍', :zht => '伍', :num => 5, :pyn => 'wu3'},
      { :zhs => '六', :zht => '六', :num => 6, :pyn => 'liu4'},
      { :zhs => '陆', :zht => '陸', :num => 6, :pyn => 'liu4'},
      { :zhs => '七', :zht => '七', :num => 7, :pyn => 'qi1'},
      { :zhs => '柒', :zht => '柒', :num => 7, :pyn => 'qi1'},
      { :zhs => '八', :zht => '八', :num => 8, :pyn => 'ba1'},
      { :zhs => '捌', :zht => '捌', :num => 8, :pyn => 'ba1'},
      { :zhs => '九', :zht => '九', :num => 9, :pyn => 'jiu3'},
      { :zhs => '玖', :zht => '玖', :num => 9, :pyn => 'jiu3'},
      { :zhs => '十', :zht => '十', :num => 10, :pyn => 'shi2'},
      { :zhs => '拾', :zht => '拾', :num => 10, :pyn => 'shi2'},
      { :zhs => '廿', :zht => '廿', :num => 20, :pyn => ' nian4'},
      { :zhs => '百', :zht => '百', :num => 100, :pyn => 'bai2'},
      { :zhs => '佰', :zht => '佰', :num => 100, :pyn => 'bai2'},
      { :zhs => '千', :zht => '千', :num => 1000, :pyn => 'qian2'},
      { :zhs => '仟', :zht => '仟', :num => 1000, :pyn => 'qian2'},
      { :zhs => '万', :zht => '萬', :num => 10000, :pyn => 'wan4'},
      { :zhs => '亿', :zht => '億', :num => 100000000, :pyn => 'yi4'},
    ]

    def number? word
      #垓	秭	穰	溝	澗	正	載 --> beyond 100,000,000!
      "#{word}".gsub(/([\d]|[一二三四五六七八九十百千萬万億亿]){2,}/,'') == ''
    end

    def zh_number_to_number(zh_number)
      zh_number = zh_number.to_s
      numbers = convert_date(zh_number)

      #if it's a year, or an oddly formatted number
      return numbers.join('').to_i if zh_number[/[#{NUMBER_MULTIPLES}]/u].nil?

      convert_numbers numbers
    end

    #these should also be able to convert numbers to chinese numbers
    def number_to_zhs type, number
      convert_number_to :zhs, type.to_sym, number
    end
    def number_to_zht type, number
      convert_number_to :zht, type.to_sym, number
    end

    def number_to_pyn number, type = 'zh_s'
      convert_number_to :pyn, type.to_sym, number, '-'
    end

    private
    def convert_date(zh)
      #if it's a year, or an oddly formatted number
      zh_numbers = ZhongwenTools::String.chars zh
      numbers = [];
      i = 0

      while( i < zh_numbers.length)
        curr_number = zh_numbers[i]

        #x[:num] == curr_number.to_i is a kludge; any string will == 0
        num = convert(curr_number)[:num]
        numbers << num
        i += 1
      end

      return numbers
    end

    def convert(number)
      NUMBERS_TABLE.find{|x|  x[:zhs] == number || x[:zht] == number  || x[:num].to_s == number}
    end

    def convert_numbers(numbers)
      number = 0
      length = numbers.length
      skipped = false

      length.times do |i|
        unless skipped == i
          curr_num = numbers[i] || 0
          if (i+2) <= length
            number, i = convert_current_number(numbers, number, curr_num, i)
            skipped = i + 1
          else
            number = adjust_number(number, curr_num)
          end
        end
      end

      number
    end

    def convert_current_number numbers, number, curr_num, i
      next_number = numbers[i + 1]
      if is_number_multiplier? next_number
        number += next_number * curr_num
      end

      [number, i]
    end
    def adjust_number(number, curr_num)
      is_number_multiplier?(curr_num) ? number * curr_num : number + curr_num
    end


    def is_number_multiplier?(number)
      [10,100,1000,10000,100000000].include? number
    end



    def check_wan(wan, i)
      wan ||= 0
      wan += 1 if (i + 1) % 5 == 0

      wan
    end

    def convert_from_zh number, to
      converted_number = number.chars.map do |digit|
        convert(digit).fetch(to){ digit }
      end
    end

    def convert_from_num number, to
      #TODO: this will fail for numbers over 1 billion. grr.
      str = number.to_s
      len = str.length
      converted_number = []

      len.times do |i|
        wan = check_wan(wan, i)
        num = str[(len - 1 - i),1].to_i

        if i == 0

          converted_number << _find_number(num, to) unless num == 0
        else
          converted_number <<  _find_wan_level(i, to)

          #checks the wan level and ...
          converted_number <<  _find_number(num, to) if (num == 1 && (10**(i) / 10000 ** wan) != 10) || num != 1
        end
      end

      converted_number.reverse!
    end

    def convert_number_to(to, from, number, separator = '')
      return number unless [:zht, :zhs, :num, :pyn].include? to

      if from == :num
        converted_number = convert_from_num(number, to)
      else
        converted_number = convert_from_zh number, to
      end

      #liang rules are tough...
      converted_number.join(separator).gsub(/零[#{NUMBER_MULTIPLES}]/u,'')#.gsub(/二([百佰千仟仟万萬亿億])/){"#{NUMBERS_TABLE.find{|x|x[:pyn] == 'liang3'}[to]}#{$1}"}
    end

    private

    def _find_wan_level(i, to)
      _find_number((10**(i)), to) || _find_number((10**(i) / 10000), to) || _find_number((10**(i) / 10000**2), to)
    end

    def _find_number(num, to)
      NUMBERS_TABLE.find{|x| x[:num] == num}.fetch(to){0}
    end
  end
end
