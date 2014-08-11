# encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'

class TestCore < Minitest::Test
  def test_core_ext_does_not_have_script_functions
    load 'test_helpers/unload_zhongwen_tools_script.rb'
    require 'zhongwen_tools/core'
    require 'zhongwen_tools/core_ext/string'
    assert_raises(NoMethodError){ '你们'.to_zht }
  end
end
