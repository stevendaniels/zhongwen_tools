  # encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'
require 'zhongwen_tools'

if RUBY_VERSION < '2.0.0'
  String.send(:include, ZhongwenTools::StringExtension)
else
  using ZhongwenTools
  puts 'using zhongwen_tools'
end

class TestStringExtention < Minitest::Test
  def setup
    @caps = { u: 'ĀLĀBÓ', d: 'ālābó', c: 'Ālābó' }
    @fw = { hw: 'hello',fw: 'ｈeｌｌｏ', mixed: 'hellｏ' }

    @rom =       {
      pyn: 'ni3 hao3',
      py: 'nǐ hǎo',
      bpmf: 'ㄋㄧ3 ㄏㄠ3',
      yale: 'ni3 hau3',
      typy: 'ni3 hao3',
      wg: 'ni3 hao3',
      mps2: 'ni3 hau3'
    }

    @zh =       {
      :zhs => '嘴里吃着鲔鱼三明治',
      :zht => '嘴裡吃著鮪魚三明治',
      :zhtw => '嘴裡吃著鮪魚三明治',
      :zhhk => '嘴裏吃着吞拿魚三文治',
      :zhcn => '嘴里吃着金枪鱼三明治'
    }
    @unicode = { codepoint:"\\u4e2d\\u6587", unicode: '中文' }
  end

  def test_methods
    assert_kind_of Array, @caps[:u].chars
    # caps.rb
    assert_equal 'Hello', 'hello'.capitalize
    assert_equal @caps[:d], @caps[:u].zh_downcase
    assert_equal @caps[:u], @caps[:c].zh_upcase

    # fullwidth.rb
    assert_equal @fw[:hw], @fw[:fw].to_halfwidth
    assert_equal @fw[:hw], @fw[:mixed].to_halfwidth
    assert @fw[:hw].halfwidth?
    assert @fw[:fw].fullwidth?
    assert @fw[:mixed].fullwidth?
    refute @fw[:mixed].halfwidth?

    # romanization
    # NOTE: MUST use eval because "Any indirect method access ... shall not honor refinements in the caller context during method lookup."
    @rom.each do |from, str|
      @rom.each do |to, expected_result|
        if [:py, :pyn].include?(from)
          assert_equal expected_result, eval("str.to_#{to}"), "'#{str}'.to_#{to} should equal #{expected_result}"
        else
          assert_equal expected_result, eval("str.to_#{to}(:#{from})"), "'#{str}'.to_#{to}(#{from}) should equal #{expected_result}"
        end
      end
    end


    # script.rb
    load 'zhongwen_tools/script.rb'  unless ZhongwenTools.const_defined?(:Script)
    assert_equal @zh[:zht], @zh[:zhs].to_zht
    assert_equal @zh[:zhs], @zh[:zht].to_zhs
    assert_equal @zh[:zhcn], @zh[:zhhk].to_zhcn
    assert_equal @zh[:zhcn], @zh[:zhtw].to_zhcn
    assert_equal @zh[:zhhk], @zh[:zhhk].to_zhhk
    assert_equal @zh[:zhhk], @zh[:zhcn].to_zhhk
    assert_equal @zh[:zhtw], @zh[:zhhk].to_zhtw
    assert_equal @zh[:zhtw], @zh[:zhcn].to_zhtw

    # unicode.rb
    assert_equal @unicode[:codepoint], @unicode[:unicode].to_codepoint
    assert_equal @unicode[:unicode], @unicode[:codepoint].from_codepoint
    refute @unicode[:unicode].ascii?
    assert @unicode[:unicode].multibyte?

    # uri.rb
    # NOTE: refinements can't test for "respond_to"
    assert ''.uri_escape
    assert ''.uri_encode

    # zhongwen.rb
    assert @zh[:zhs].zh?
    assert @zh[:zhs].has_zh?
    assert '。'.has_zh_punctuation?
    assert_equal '你好', '你好！'.strip_zh_punctuation
  end
end
