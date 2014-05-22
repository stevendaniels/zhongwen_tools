#encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require './test/test_helper'
require 'zhongwen_tools/string'
require 'zhongwen_tools/romanization'

class String
  include ZhongwenTools::Romanization
end

class TestRomanization < Minitest::Test

  def test_pinyin
    assert_equal 'Zhōng wén','Zhong1 wen2'.to_pinyin
    assert_equal 'Zhōngwén', 'Zhong1-wen2'.to_pinyin
    assert_equal "Tiān'ānmén",'Tian1an1men2'.to_pinyin
    assert_equal @alabo[:py], @alabo[:pyn].to_pinyin

    #wg -> py not yet implemented
    #mzd = "Mao Tse-tung"
    #assert_equal "Mao Zedong", mzd.to_pinyin(:wg)
  end

  def test_pyn
    assert_equal 'ni3 hao3', @py.to_pyn(:py)
    assert_equal 'tian1an1men2', 'tian1an1men2'.to_py.to_pyn(:py)

    #assert_equal 'Wūlúhānuòfū'.to_pyn, 'Wu1-lu2-ha1-nuo4-fu1'
    #"007：Dàpò Liàngzǐ Wēijī", "007: Da4po4 Liang4zi3 Wei1ji1"
  end

  def test_zhuyin_fuhao
     assert_equal 'ㄋㄧ3 ㄏㄠ3', @str.to_bpmf
     assert_equal 'ㄋㄧ3 ㄏㄠ3', @str.to_bopomofo
     assert_equal 'ㄋㄧ3 ㄏㄠ3', @str.to_zhuyin
     assert_equal 'ㄇㄠ2 ㄗㄜ2 ㄉㄨㄥ1', @mzd.to_zhuyin_fuhao
     assert_equal 'ㄑㄧㄥ3 ㄏㄨㄟ2ㄉㄚ2 ㄨㄛ3 ㄉㄜ5 ㄨㄣ4ㄊㄧ2 .', @sent.to_zhuyin
     assert_equal 'ㄇㄠ2 ㄗㄜ2ㄉㄨㄥ1', @mzd2.to_zhuyin_fuhao
     assert 'ㄋㄧ3 ㄏㄠ3'.zyfh?
  end

  def test_wade_giles
    assert_equal 'kuo1', 'guo1'.to_wg
    assert_equal 'chung1 kuo2', 'zhong1 guo2'.to_wg
    assert_equal 'Mao2 Tse2 tung1', @mzd.to_wg
    assert_equal 'Mao2 Tse2-tung1', @mzd2.to_wade_giles
    assert_equal 'Mao2 Tse2-tung1 te5 mao2', 'Mao2 Ze2-dong1 de5 mao2'.to_wade_giles
  end

  #def test_mspy2
    #skip
    #assert_equal '', @str.to_mspy2
  #end

  def test_typy
    #skip
    pyn = 'chui1 niu3'
    typy = 'chuei1 niou3'
    assert_equal typy, pyn.to_typy
    # FIXME: to_typy doesn't work with non-spaced pinyin.
    #assert_equal typy, typy.to_pyn(:typy)
    assert typy.typy?
    refute pyn.typy?
  end

  def test_yale
    assert_equal 'ni3 hau3', @str.to_yale
  end

  def test_romanization?
    assert_equal :pyn, @alabo[:pyn].romanization?
    assert_equal :py, @alabo[:py].romanization?
    assert_equal :wg, @mzd.to_wg(:pyn).romanization?
  end

  def test_detect
    assert @str.pyn?
    assert " #{@str}".pyn?
    refute @py.pyn?

    assert 'chung1 kuo2'.wg?

    # Travis CI is having trouble with this using Ruby 1.8.7, but it works locally.
    # I'll probably end up dropping full 1.8.7 support.
    assert @py.py?, "#{@py} should be pinyin. (#{@py.py?})" unless RUBY_VERSION < '1.9'

    #TODO yale test
    #zhyfh detect
    #typy detect
    #msp2 detect
  end

  def test_split_pyn
    assert_equal 'zhong1guo2'.split_pyn, %w(zhong1 guo2)
    assert_equal 'dong1xi'.split_pyn, %w(dong1 xi)
    assert_equal 'zhongguo'.split_pyn, %w(zhong guo)
    assert_equal 'dong1 xi1 '.split_pyn, %w(dong1 xi1)
    assert_equal @mzd2.split_pyn, %w(Mao2 Ze2 dong1)
  end

  def setup
    @romanizations = [
      { :pyn => '', :py => '', :bopomofo => '', :yale => '', :typy => '', :wg => '', :ipa => ''}
    ]
    @str = 'ni3 hao3'
    @mzd = 'Mao2 Ze2 dong1'
    @mzd2 = 'Mao2 Ze2-dong1'
    @py = 'nǐ hǎo'
    @sent = 'Qing3 hui2-da2 wo3 de5 wen4-ti2 .'
    @alabo = {:pyn => 'A1-la1-bo2', :py => 'Ālābó'}
  end
end
