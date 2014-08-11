# encoding: utf-8
require 'zhongwen_tools/regex'

module ZhongwenTools
  module Fullwidth
    # TODO: type checking.
    def self.halfwidth?(str)
      str[ZhongwenTools::Regex.fullwidth].nil?
    end

    def self.fullwidth?(str)
      !halfwidth?(str) && to_halfwidth(str) != str
    end

    def self.to_halfwidth(str)
      str.gsub(/(#{ZhongwenTools::Regex.fullwidth})/, ZhongwenTools::Fullwidth::FW_HW)
    end

    FW_HW ={
      "０" => "0",
      "１" => "1",
      "２" => "2",
      "３" => "3",
      "４" => "4",
      "５" => "5",
      "６" => "6",
      "７" => "7",
      "８" => "8",
      "９" => "9",
      "Ａ" => "A",
      "Ｂ" => "B",
      "Ｃ" => "C",
      "Ｄ" => "D",
      "Ｅ" => "E",
      "Ｆ" => "F",
      "Ｇ" => "G",
      "Ｈ" => "H",
      "Ｉ" => "I",
      "Ｊ" => "J",
      "Ｋ" => "K",
      "Ｌ" => "L",
      "Ｍ" => "M",
      "Ｎ" => "N",
      "Ｏ" => "O",
      "Ｐ" => "P",
      "Ｑ" => "Q",
      "Ｒ" => "R",
      "Ｓ" => "S",
      "Ｔ" => "T",
      "Ｕ" => "U",
      "Ｖ" => "V",
      "Ｗ" => "W",
      "Ｘ" => "X",
      "Ｙ" => "Y",
      "Ｚ" => "Z",
      "ａ" => "a",
      "ｂ" => "b",
      "ｃ" => "c",
      "ｄ" => "d",
      "ｅ" => "e",
      "ｆ" => "f",
      "ｇ" => "g",
      "ｈ" => "h",
      "ｉ" => "i",
      "ｊ" => "j",
      "ｋ" => "k",
      "ｌ" => "l",
      "ｍ" => "m",
      "ｎ" => "n",
      "ｏ" => "o",
      "ｐ" => "p",
      "ｑ" => "q",
      "ｒ" => "r",
      "ｓ" => "s",
      "ｔ" => "t",
      "ｕ" => "u",
      "ｖ" => "v",
      "ｗ" => "w",
      "ｘ" => "x",
      "ｙ" => "y",
      "ｚ" => "z",
      "％" => '%',
      "．" => '.',
      '：' => ':',
      "＃" => '#',
      "＄" => "$",
      "＆" => "&",
      "＋" => "+",
      "－" => "-",
      "／" => "/",
      "＼" => '\\',
      '＝' => '=',
      "；" => ";",
      "＜" => "<",
      "＞" => ">",
      "？" => "?",
      "。" => ".",
      "！" => "!",
      '，' => ','
    }
  end
end
