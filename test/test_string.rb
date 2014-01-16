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
  
  def setup
    @str = '中文'
  end

end
