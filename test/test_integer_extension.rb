# encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'
require 'zhongwen_tools/integer_extension'
class TestIntegerExtention < Minitest::Test
  using ZhongwenTools
  def test_to_zh
    assert_equal @yi[:zhs], @yi[:i].to_zh(:zhs)
    assert_equal @yi[:zht], @yi[:i].to_zh(:zht)
  end

  def test_to_zht
    assert_equal @yi[:zht], @yi[:i].to_zht
  end

  def test_to_zhs
    assert_equal @yi[:zhs], @yi[:i].to_zhs
  end

  def test_to_pyn
    assert_equal @yi[:pyn], @yi[:i].to_pyn
  end

  def setup
    @yi = { i: 10_000, zhs: '一万', zht: '一萬', pyn: 'yi1-wan4' }
  end
end
