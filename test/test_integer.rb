#encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'
require 'zhongwen_tools/integer'

class Integer
  include ZhongwenTools::Integer
end

class TestInteger < Minitest::Test
  def test_zh
    assert_equal 122.to_zh, '一百二十二'
    assert_equal 12.to_zh, '十二'
    assert_equal 12000.to_zht, '一萬二千'
    assert_equal 12000.to_zhs, '一万二千'
    refute 12000.to_zh == 12000.to_zht


    assert_equal '十二', ZhongwenTools::Integer.to_zhs(12)
    assert_equal '一萬二千', ZhongwenTools::Integer.to_zht(12000)
    assert_equal '一万二千', ZhongwenTools::Integer.to_zhs(12000)
    refute  ZhongwenTools::Integer.to_zhs(12000) == ZhongwenTools::Integer.to_zht(12000)
  end

  def test_pinyin
    assert_equal 12.to_pyn, 'shi2-er4'
    assert_equal 'shi2-er4', ZhongwenTools::Integer.to_pyn(12)
  end
end

