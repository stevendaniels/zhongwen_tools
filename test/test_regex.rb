# encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'
require 'zhongwen_tools/regex'
class TestRegex < Minitest::Test

  def test_pyn_regexes
    assert 'hao3'[ZhongwenTools::Regex.pyn]
  end

  def test_py_regexes
    assert 'hǎo'[ZhongwenTools::Regex.py ]
  end

  def test_numbers
    str = '二'
    assert str, str[ZhongwenTools::Regex.zh_numbers]

    str = '两'
    assert str[ZhongwenTools::Regex.zhs_numbers]
    refute str[ZhongwenTools::Regex.zht_numbers]

    str = '兩'
    refute str[ZhongwenTools::Regex.zhs_numbers]
    assert str[ZhongwenTools::Regex.zht_numbers]
  end

  def test_punctuation
    refute '.'[ZhongwenTools::Regex.zh_punc]
    assert '.'[ZhongwenTools::Regex.punc]
    assert '。'[ZhongwenTools::Regex.zh_punc]
    refute '。'[ZhongwenTools::Regex.punc]
  end

  def test_zh
    assert '中'[ZhongwenTools::Regex.zh]
    refute 'a'[ZhongwenTools::Regex.zh]
    refute 'ご'[ZhongwenTools::Regex.zh]
  end
end
