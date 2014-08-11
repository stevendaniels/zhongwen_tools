# encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'
require 'zhongwen_tools/unicode'
class TestUnicode < Minitest::Test
  def test_to_codepoint
    assert_equal "\\u4e2d\\u6587", ZhongwenTools::Unicode.to_codepoint('中文')
    assert_equal "\\u4e2d", ZhongwenTools::Unicode.to_codepoint('中')
  end

  def test_from_codepoint
    assert_equal  '中', ZhongwenTools::Unicode.from_codepoint("\\u4e2d")
    assert_equal '中文', ZhongwenTools::Unicode.from_codepoint("\\u4e2d\\u6587")
  end

  def test_ascii
    refute ZhongwenTools::Unicode.ascii?('中文')
    assert ZhongwenTools::Unicode.ascii?('Chinese')
  end

  def test_multibyte
    assert ZhongwenTools::Unicode.multibyte?('中文')
    refute ZhongwenTools::Unicode.multibyte?('Chinese')
  end
end

