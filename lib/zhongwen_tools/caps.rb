# encoding: utf-8
module ZhongwenTools
  # Public: Module for pinyin/fullwidth capitalization
  module Caps
    def self.downcase(str)
      regex = /(#{ZhongwenTools::Caps::CAPS.keys.join('|')})/
      str.gsub(regex, ZhongwenTools::Caps::CAPS).downcase
    end

    def self.upcase(str)
      str.gsub(/(#{ZhongwenTools::Caps::CAPS.values.join('|')})/) do
        ZhongwenTools::Caps::CAPS.find { |_, v| v == Regexp.last_match[0] }[0]
      end.upcase
    end

    def self.capitalize(str)
      first_letter = str[/#{Regex.py}|[ĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒ]/][0]
      str.sub(first_letter, ZhongwenTools::Caps.upcase(first_letter))
    end

    CAPS = {
      'Ā' => 'ā',
      'Á' => 'á',
      'Ǎ' => 'ǎ',
      'À' => 'à',
      'Ē' => 'ē',
      'É' => 'é',
      'Ě' => 'ě',
      'È' => 'è',
      'Ī' => 'ī',
      'Í' => 'í',
      'Ǐ' => 'ǐ',
      'Ì' => 'ì',
      'Ō' => 'ō',
      'Ó' => 'ó',
      'Ǒ' => 'ǒ',
      'Ò' => 'ò',
      'Ǖ' => 'ǖ', # using combining diatrical marks
      'Ǘ' => 'ǘ', # using combining diatrical marks
      'Ǚ' => 'ǚ', # using combining diatrical marks
      'Ǜ' => 'ǜ', # using combining diatrical marks
      'Ū' => 'ū',
      'Ú' => 'ú',
      'Ǔ' => 'ǔ',
      'Ù' => 'ù',
      'Ａ' => 'ａ',
      'Ｂ' => 'ｂ',
      'Ｃ' => 'ｃ',
      'Ｄ' => 'ｄ',
      'Ｅ' => 'ｅ',
      'Ｆ' => 'ｆ',
      'Ｇ' => 'ｇ',
      'Ｈ' => 'ｈ',
      'Ｉ' => 'ｉ',
      'Ｊ' => 'ｊ',
      'Ｋ' => 'ｋ',
      'Ｌ' => 'ｌ',
      'Ｍ' => 'ｍ',
      'Ｎ' => 'ｎ',
      'Ｏ' => 'ｏ',
      'Ｐ' => 'ｐ',
      'Ｑ' => 'ｑ',
      'Ｒ' => 'ｒ',
      'Ｓ' => 'ｓ',
      'Ｔ' => 'ｔ',
      'Ｕ' => 'ｕ',
      'Ｖ' => 'ｖ',
      'Ｗ' => 'ｗ',
      'Ｘ' => 'ｘ',
      'Ｙ' => 'ｙ',
      'Ｚ' => 'ｚ'
    }
  end
end
