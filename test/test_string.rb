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
    assert_equal 2, '中文'.size
  end

  def test_chars
    assert_equal %w(中 文), '中文'.chars
  end

  def test_reverse
    assert_equal '文中', '中文'.reverse
  end

  def test_latin
    refute '中文'.ascii?
    assert 'zhongwen'.ascii?
    assert '中文'.multibyte?
  end
  
  def test_halfwidth
    str = 'hellｏ'
    refute str.halfwidth?
    assert str.to_halfwidth.halfwidth?
    assert_equal str.to_halfwidth, 'hello'
  end

  def test_fullwidth
    str = 'hellｏ'
    assert str.fullwidth?
  end

end
