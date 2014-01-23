#encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require './test/test_helper'
require 'zhongwen_tools/string'
require 'zhongwen_tools/romanization'

class String
  include ZhongwenTools::Romanization
end

class TestRomanization < Test::Unit::TestCase

  def test_pinyin
    assert_equal 'Zhōng wén','Zhong1 wen2'.to_pinyin
    assert_equal 'Zhōngwén', 'Zhong1-wen2'.to_pinyin
    assert_equal "Tiān'ānmén",'Tian1an1men2'.to_pinyin

    #skip
    #mzd = "Mao Tse-tung"
    #assert_equal "Mao Zedong", mzd.to_pinyin(:wg)
  end

  def test_pyn
    skip
    assert_equal 'ni3 hao3', @py.to_pyn
  end

  def test_zhuyin_fuhao
     assert_equal 'ㄋㄧ3 ㄏㄠ3', @str.to_bpmf
     assert_equal 'ㄋㄧ3 ㄏㄠ3', @str.to_bopomofo
     assert_equal 'ㄋㄧ3 ㄏㄠ3', @str.to_zhuyin
     assert_equal 'ㄇㄠ2 ㄗㄜ2 ㄉㄨㄥ1', @mzd.to_zhuyin_fuhao
#skip
     #assert_equal 'ㄇㄠ2 ㄗㄜ2ㄉㄨㄥ1', @mzd2.to_zhuyin_fuhao
  end

  def test_wade_giles
    assert_equal 'kuo1', 'guo1'.to_wg
    assert_equal 'chung1 kuo2', 'zhong1 guo2'.to_wg
    #assert_equal 'Mao2 Tse2 tung1', @mzd.to_wg
    #assert_equal 'Mao2 Tse2 tung1', @mzd.to_wade_giles
  end

  #def test_mspy2
    #skip
    #assert_equal '', @str.to_mspy2
  #end

  def test_typy
    skip
    assert_equal '', @str.to_typy
    assert_equal '', @str.to_tongyong
  end

  def test_yale
    assert_equal 'ni3 hau3', @str.to_yale
  end

  def test_romanization?
    skip
  end

  def test_detect
    assert @str.pyn?
    refute @py.pyn?
  end

  def setup
    @str = 'ni3 hao3'
    @mzd = 'Mao2 Ze2 dong1'
    @mzd2 = 'Mao2 Ze2-dong1'
    @py = 'nǐ hǎo'
  end
end
