# encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'
require 'zhongwen_tools/fullwidth'
class TestFullwidth < Minitest::Test
  def setup
    @hw = 'hello'
    @fw = 'ｈeｌｌｏ'
    @mixed = 'hellｏ'
  end

  def test_halfwidth?
    assert ZhongwenTools::Fullwidth.halfwidth? @hw
    refute ZhongwenTools::Fullwidth.halfwidth? @fw
    refute ZhongwenTools::Fullwidth.halfwidth? @mixed
  end

  def test_fullwidth?
    refute ZhongwenTools::Fullwidth.fullwidth? @hw
    assert ZhongwenTools::Fullwidth.fullwidth? @fw
    assert ZhongwenTools::Fullwidth.fullwidth? @mixed
  end

  def test_to_halfwidth
    assert_equal @hw, ZhongwenTools::Fullwidth.to_halfwidth(@fw)
    assert_equal @hw, ZhongwenTools::Fullwidth.to_halfwidth(@mixed)
  end
end

