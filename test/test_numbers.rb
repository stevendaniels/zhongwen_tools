#encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'
require 'zhongwen_tools/string'
require 'zhongwen_tools/numbers'

class TestNumbers < Minitest::Test
  include ZhongwenTools::Numbers
  def test_convert_to_numbers
    #skip
    #your function sucks dick man
    @numbers.each do |num|
      number = zh_number_to_number num[:zh]
      binding.pry if num[:en] != number
      assert_equal num[:en], number
    end
  end

  def test_convert_to_traditional_number
    zhs = @numbers[0][:zh]
    zht = number_to_zht :zht, zhs

    assert_equal '一萬兩千七', zht
  end

  def test_convert_to_simplified_from_number
    num = @numbers[0][:en]
    zhs = number_to_zhs :num, num

    assert_equal '一万二千七', zhs
  end

  def test_convert_number_to_pyn
    num = '一百三十六'
    pyn = self.number_to_pyn num

    assert_equal 'yi1-bai2-san1-shi2-liu4', pyn
  end

  def setup
    @numbers = [
      {:zh =>'一万两千七', :en => 12007},
      {:zh => '三千六十三', :en => 3063},
      {:zh => '一百五十', :en => 150 },
      {:zh => '三千亿', :en => 300000000000},
      {:zh => '一九六六', :en => 1966},
      {:zh => '二零零八', :en => 2008},
    ]
  end
end
