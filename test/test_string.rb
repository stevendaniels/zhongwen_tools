#encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')
#require 'rubygems'
  #gem 'guard'
  #gem 'guard-bundler'
  #gem 'guard-minitest'
  #gem 'pry'
  #gem 'pry-rescue'
  #gem 'pry-stack_explorer'
  #gem 'rb-fsevent', :require => false

#require 'bundler'
#Bundler.require :default, 'test'

require 'test/unit'

require 'zhongwen_tools/string.rb'

class String
  include ZhongwenTools::String
end
class TestString < Test::Unit::TestCase
  def test_size
    assert_equal 2, @str.size
    assert_equal 2, ZhongwenTools::String.size(@str)
  end

  def test_chars
    assert_equal %w(中 文), @str.chars
    
    assert_equal %w(中 文), ZhongwenTools::String.chars(@str)
  end

  def test_reverse
    assert_equal '文中', '中文'.reverse
    
    assert_equal '文中', ZhongwenTools::String.reverse('中文')
  end

  def test_latin
    refute @str.ascii?
    assert 'zhongwen'.ascii?
    assert @str.multibyte?

    
    refute ZhongwenTools::String.ascii? @str
    assert ZhongwenTools::String.ascii? 'zhongwen'
    assert ZhongwenTools::String.multibyte? @str
  end
  
  def test_halfwidth
    str = 'hellｏ'
    refute str.halfwidth?
    assert_equal str.to_halfwidth, 'hello'
    assert str.to_halfwidth.halfwidth?

    
    refute ZhongwenTools::String.halfwidth? str
    assert_equal ZhongwenTools::String.to_halfwidth(str), 'hello'
    assert ZhongwenTools::String.halfwidth?(ZhongwenTools::String.to_halfwidth(str))
  end

  def test_fullwidth
    str = 'hellｏ'
    assert str.fullwidth?

    assert  ZhongwenTools::String.fullwidth? str
  end

  def test_uri_encode
    url = 'http://www.3000hanzi.com/chinese-to-english/definition/好'
    assert_equal URI.encode('好'), '好'.uri_encode

    assert_equal "http://www.3000hanzi.com/chinese-to-english/definition/#{URI.encode '好'}", ZhongwenTools::String.uri_encode(url)
    assert_equal "http://www.3000hanzi.com/chinese-to-english/definition/#{URI.encode '好'}", url.uri_encode
  end

  def test_uri_encode
    url = 'http://www.3000hanzi.com/chinese-to-english/definition/好'
    regex = Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")

    assert_equal URI.escape(url, regex), ZhongwenTools::String.uri_escape(url)
    assert_equal URI.escape(url, regex), url.uri_escape
  end

  def test_has_zh
    assert @str.has_zh?
    refute @hw.has_zh?
    refute @fw.has_zh?

    assert ZhongwenTools::String.has_zh? @str
    refute ZhongwenTools::String.has_zh? @hw
    refute ZhongwenTools::String.has_zh? @fw
  end

  def test_is_zh
    assert @str.zh?
    assert @zh_punc.zh?

    assert ZhongwenTools::String.zh? @str
    assert ZhongwenTools::String.zh? @zh_punc
  end

  def test_codepoint
    assert_equal "\\u4e2d\\u6587", @str.to_codepoint
    assert_equal '羊', 'u7f8a'.from_codepoint
    assert_equal '羊', '\\u7f8a'.from_codepoint

    assert_equal "\\u4e2d\\u6587", ZhongwenTools::String.to_codepoint(@str)
    assert_equal '羊', ZhongwenTools::String.from_codepoint('u7f8a')
    assert_equal '羊', ZhongwenTools::String.from_codepoint('\\u7f8a')
  end

  def test_punctuation
    assert ZhongwenTools::String.has_zh_punctuation?(@zh_punc)

    assert @zh_punc.has_zh_punctuation?
  end

  def setup
    @str = '中文'
    @fw = 'ｈｅｌｌｏ'
    @hw = 'hello'
    @zh_punc = '不错吧！'
  end

end
