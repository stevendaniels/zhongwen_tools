# encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'
require 'zhongwen_tools/number'
class TestNumber < Minitest::Test
  def setup
    @numbers = [
      { zhs: '一万二千七', zht: '一萬二千七', i: 12_007, pyn: 'yi1-wan4-er4-qian1-qi1' },
      { zhs: '三千六十三', zht: '三千六十三', i: 3_063, pyn: 'san1-qian1-liu4-shi2-san1' },
      { zhs: '一百五十',   zht: '一百五十', i: 150, pyn: 'yi1-bai2-wu3-shi2' },
      #{ zhs: '三千亿', i: 300_000_000_000, pyn: '' },
    ]

    @liang_number = { zhs: '一万两千七', i: 12_007, pyn: '' }
    @date_numbers = [
      { zhs: '一九六六', i: 1966, pyn: '' },
      { zhs: '二零零八', i: 2008, pyn: '' },
    ]
  end

  def test_number?
    assert ZhongwenTools::Number.number? '一'
    assert ZhongwenTools::Number.number? 1

    @numbers.map{ |n| n[:zhs]}.each do |zh|
      assert ZhongwenTools::Number.number?(zh), "#{zh}"
    end
  end

  def test_to_pyn
    # same tests
    @numbers.each do |n|
      [:i, :pyn, :zhs, :zht].each do |type|
        assert_equal n[:pyn], ZhongwenTools::Number.to_pyn(n[type])
      end
    end

  end

  def test_to_zhs
    @numbers.each do |n|
      [:i, :pyn, :zht, :zhs].each do |type|
        assert_equal n[:zhs], ZhongwenTools::Number.to_zhs(n[type])
      end
    end
  end

  def test_to_zht
    @numbers.each do |n|
      [:i, :pyn, :zhs, :zht].each do |type|
        assert_equal n[:zht], ZhongwenTools::Number.to_zht(n[type])
      end
    end
  end

  def test_to_zh
    @numbers.each do |n|
      [:i, :pyn, :zhs, :zht].each do |type|
        assert_equal n[:zhs], ZhongwenTools::Number.to_zh(n[type], :zhs)
        assert_equal n[:zht], ZhongwenTools::Number.to_zh(n[type], :zht)
      end
    end
  end

  def test_to_i
    assert_equal @liang_number[:i], ZhongwenTools::Number.to_i(@liang_number[:zhs])

    @numbers.each do |n|
      [:pyn, :zhs, :zht].each do |type|
        assert_equal n[:i], ZhongwenTools::Number.to_i(n[type])
      end
    end

    @date_numbers.each do |n|
        assert_equal n[:i], ZhongwenTools::Number.to_i(n[:zhs])
    end
  end

  def test_large_numbers
    assert_equal '五十万',  ZhongwenTools::Number.to_zhs(500_000)
    assert_equal '五十亿',  ZhongwenTools::Number.to_zhs(5_000_000_000)
    #assert_equal '五万亿',  ZhongwenTools::Number.to_zhs(5_000_000_000_000)
  end
end
