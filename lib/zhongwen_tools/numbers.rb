#encoding: utf-8
module ZhongwenTools
  module Numbers

    NUMBER_MULTIPLES = '拾十百佰千仟仟万萬亿億'

    NUMBERS_TABLE = [
      { :zh_s => '零', :zh_t => '零', :num => 0, :pyn => 'ling2'},
      { :zh_s => '〇', :zh_t => '〇', :num => 0, :pyn => 'ling2'},
      { :zh_s => '一', :zh_t => '一', :num => 1, :pyn => 'yi1'},
      { :zh_s => '壹', :zh_t => '壹', :num => 1, :pyn => 'yi1'},
      { :zh_s => '幺', :zh_t => '幺', :num => 1, :pyn => 'yao1'},
      { :zh_s => '二', :zh_t => '二', :num => 2, :pyn => 'er4'},
      { :zh_s => '两', :zh_t => '兩', :num => 2, :pyn => 'liang3'},
      { :zh_s => '贰', :zh_t => '貳', :num => 2, :pyn => 'er4'},
      { :zh_s => '三', :zh_t => '三', :num => 3, :pyn => 'san1'},
      { :zh_s => '弎', :zh_t => '弎', :num => 3, :pyn => 'san1'},
      { :zh_s => '叁', :zh_t => '參', :num => 3, :pyn => 'san1'},
      { :zh_s => '四', :zh_t => '四', :num => 4, :pyn => 'si4'},
      { :zh_s => '䦉', :zh_t => '䦉', :num => 4, :pyn => 'si4'},
      { :zh_s => '肆', :zh_t => '肆', :num => 4, :pyn => 'si4'},
      { :zh_s => '五', :zh_t => '五', :num => 5, :pyn => 'wu3'},
      { :zh_s => '伍', :zh_t => '伍', :num => 5, :pyn => 'wu3'},
      { :zh_s => '六', :zh_t => '六', :num => 6, :pyn => 'liu4'},
      { :zh_s => '陆', :zh_t => '陸', :num => 6, :pyn => 'liu4'},
      { :zh_s => '七', :zh_t => '七', :num => 7, :pyn => 'qi1'},
      { :zh_s => '柒', :zh_t => '柒', :num => 7, :pyn => 'qi1'},
      { :zh_s => '八', :zh_t => '八', :num => 8, :pyn => 'ba1'},
      { :zh_s => '捌', :zh_t => '捌', :num => 8, :pyn => 'ba1'},
      { :zh_s => '九', :zh_t => '九', :num => 9, :pyn => 'jiu3'},
      { :zh_s => '玖', :zh_t => '玖', :num => 9, :pyn => 'jiu3'},
      { :zh_s => '十', :zh_t => '十', :num => 10, :pyn => 'shi2'},
      { :zh_s => '拾', :zh_t => '拾', :num => 10, :pyn => 'shi2'},
      { :zh_s => '廿', :zh_t => '廿', :num => 20, :pyn => ' nian4'},
      { :zh_s => '百', :zh_t => '百', :num => 100, :pyn => 'bai2'},
      { :zh_s => '佰', :zh_t => '佰', :num => 100, :pyn => 'bai2'},
      { :zh_s => '千', :zh_t => '千', :num => 1000, :pyn => 'qian2'},
      { :zh_s => '仟', :zh_t => '仟', :num => 1000, :pyn => 'qian2'},
      { :zh_s => '万', :zh_t => '萬', :num => 10000, :pyn => 'wan4'},
      { :zh_s => '亿', :zh_t => '億', :num => 100000000, :pyn => 'yi4'},
    ]

    def is_number? word
      #垓	秭	穰	溝	澗	正	載 --> beyond 100,000,000!
      "#{word}".gsub(/([\d]|[一二三四五六七八九十百千萬万億亿]){2,}/,'') == ''
    end

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
      NUMBERS_TABLE.find{|x|  x[:zh_s] == number || x[:zh_t] == number  || x[:num].to_s == number}
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

    def convert_chinese_numbers_to_numbers(zh_number)
      zh_number = zh_number.to_s
      numbers = convert_date(zh_number)

      #if it's a year, or an oddly formatted number
      return numbers.join('').to_i if zh_number[/[#{NUMBER_MULTIPLES}]/u].nil?

      convert_numbers numbers
    end

    def is_number_multiplier?(number)
      [10,100,1000,10000,100000000].include? number
    end

    #these should also be able to convert numbers to chinese numbers
    def convert_number_to_simplified type, number
      convert_number_to :zh_s, type.to_sym, number
    end
    def convert_number_to_traditional type, number
      convert_number_to :zh_t, type.to_sym, number
    end

    def convert_number_to_pyn number, type = 'zh_s'
      convert_number_to :pyn, type.to_sym, number, '-'
    end


    def check_wan(wan, i)
      wan ||= 0
      wan += 1 if (i + 1) % 5 == 0
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
          replacement = NUMBERS_TABLE.find{|x| x[:num] == num}.fetch(to){0}

          converted_number << replacement unless num == 0
        else
          replacement = (NUMBERS_TABLE.find{|x| x[:num] == (10**(i))} || NUMBERS_TABLE.find{|x| x[:num] == (10**(i) / 10000)} || NUMBERS_TABLE.find{|x| x[:num] == (10**(i) / 10000**2)} )[to]
          converted_number << replacement

          #checks the wan level and ...
          if (num == 1 && (10**(i) / 10000 ** wan) != 10) || num != 1
            replacement = NUMBERS_TABLE.find{|x| x[:num] == num}[to]
            converted_number << replacement
            #elsif num != 1
            #replacement = NUMBERS_TABLE.find{|x| x[:num] == num}[to]
            #converted_number << replacement
          end
        end
      end
    end

    def convert_number_to(to, from, number, separator = '')
      return number unless [:zh_t, :zh_s, :num, :pyn].include? to


      if from == :num
         converted_number = convert_from_num(number, to).reverse!
      #end

        #converted_number.reverse!
      else
        converted_number = convert_from_zh number, to
      end
      converted_number.join(separator).gsub(/零[#{NUMBER_MULTIPLES}]/u,'')#.gsub(/二([百佰千仟仟万萬亿億])/){"#{NUMBERS_TABLE.find{|x|x[:pyn] == 'liang3'}[to]}#{$1}"}
      #liang rules are tough...
    end
  end
end
