# encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'
require 'zhongwen_tools/zhongwen'

class TestZhongwen < Minitest::Test
  def setup
    @hw = 'hello'
    @fw = 'ｈeｌｌｏ'
    @mixed = '你好Kailin'
    @zh = '你好'
  end

  def test_has_zh?
    assert ZhongwenTools::Zhongwen.has_zh? @zh
    assert ZhongwenTools::Zhongwen.has_zh? @mixed
    refute ZhongwenTools::Zhongwen.has_zh? @hw
    refute ZhongwenTools::Zhongwen.has_zh? @fw
  end

  def test_zh?
    assert ZhongwenTools::Zhongwen.zh? @zh
    refute ZhongwenTools::Zhongwen.zh? @mixed
    refute ZhongwenTools::Zhongwen.zh? @hw
    refute ZhongwenTools::Zhongwen.zh? @fw
  end

  def test_has_zh_punctuation
    assert ZhongwenTools::Zhongwen.has_zh_punctuation?('你好！')
    refute ZhongwenTools::Zhongwen.has_zh_punctuation?('你好')
  end

  def test_strip_zh_punctuation
    assert_equal '你好', ZhongwenTools::Zhongwen.strip_zh_punctuation('你好！')
  end
end
