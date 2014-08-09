# encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'
require 'zhongwen_tools/uri'
class TestUri < Minitest::Test
  def test_uri_encode
    str = '你们'
    assert_equal URI.encode(str), ZhongwenTools::URI.encode(str)
  end

  def test_uri_escape
    str = '你们'
    assert_equal URI.escape(str), ZhongwenTools::URI.escape(str)
  end
end
