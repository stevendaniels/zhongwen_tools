# encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'
require 'zhongwen_tools/caps'

class TestCaps < Minitest::Test
  def test_downcase
    assert_equal @caps[:d], ZhongwenTools::Caps.downcase(@caps[:u])
    assert_equal @caps[:d], ZhongwenTools::Caps.downcase(@caps[:c])
  end

  def test_upcase
    assert_equal @caps[:u], ZhongwenTools::Caps.upcase(@caps[:d])
    assert_equal @caps[:u], ZhongwenTools::Caps.upcase(@caps[:c])
  end

  def test_capitalize
    assert_equal @caps[:c], ZhongwenTools::Caps.capitalize(@caps[:d])
    assert_equal '"Zheng4qie1"', ZhongwenTools::Caps.capitalize('"Zheng4qie1"')
  end

  def setup
    @caps = { u: 'ĀLĀBÓ', d: 'ālābó', c: 'Ālābó' }
  end
end
