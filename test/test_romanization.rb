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
    assert_equal 'r', 'r5'.to_pinyin
    #wg -> py not yet implemented
    #mzd = "Mao Tse-tung"
    #assert_equal "Mao Zedong", mzd.to_pinyin(:wg)
    assert @alabo[:py].py?
    assert 'Ā-lā-bó'.py?
    assert 'Zhong1 wen2'.to_pinyin.py?
  end

  def test_pyn
    assert_equal 'ni3 hao3', @py.to_pyn(:py)
    assert_equal 'tian1an1men2', 'tian1an1men2'.to_py.to_pyn(:py)

    assert_equal 'yi4', 'yì'.to_pyn(:py)

    assert_equal 'ni3 hao3', 'ㄋㄧ3 ㄏㄠ3'.to_pyn(:bpmf)
    assert_equal 'ni3 hao3', 'ㄋㄧ3 ㄏㄠ3'.to_pyn
    assert_equal 'zhong1 guo2', 'chung1 kuo2'.to_pyn(:wg)
    assert_equal 'zhong1 guo2', 'chung1 kuo2'.to_pyn
    assert_equal 'chui1 niu3', 'chuei1 niou3'.to_pyn(:typy)
    assert_equal 'cao3 di4', 'tsau3 di4'.to_pyn(:mspy2)
    assert_equal 'cao3 di4', 'tsau3 di4'.to_pyn
    assert_equal 'cao3 di4', 'tsau3 di4'.to_pyn(:yale)
    assert_equal 'cao3 di4', 'tsau3 di4'.to_pyn

    #assert_equal 'Wu1-lu2-ha1-nuo4-fu1', 'Wūlúhānuòfū'.to_pyn(:py)
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

     assert_equal 'ㄋㄧ3 ㄏㄠ3', 'ni3 hau3'.to_bpmf(:yale)
  end

  def test_wade_giles
    assert_equal 'kuo1', 'guo1'.to_wg
    assert_equal 'chung1 kuo2', 'zhong1 guo2'.to_wg
    assert_equal 'Mao2 Tse2 tung1', @mzd.to_wg
    assert_equal 'Mao2 Tse2-tung1', @mzd2.to_wade_giles
    assert_equal 'Mao2 Tse2-tung1 te5 mao2', 'Mao2 Ze2-dong1 de5 mao2'.to_wade_giles

    assert_equal 'ni3 hao3', 'ni3 hau3'.to_wg(:yale)
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

    assert_equal 'chwei1 nyou3', 'chuei1 niou3'.to_yale(:typy)
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

    assert @py.py?, "#{@py} should be pinyin. (#{@py.py?})" unless RUBY_VERSION < '1.9'
    assert 'chuei1 niou3'.typy?
    assert 'ㄋㄧ3 ㄏㄠ3'.bpmf?
    assert 'ni3 hau3'.yale?
    assert 'tsuen'.mps2?
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
      # FIXME: bopomofo, tongyong pinyin, wade-giles tones are all wrong.
      # TODO: test IPA
      { :pyn => 'ni3 hao', :py => 'nǐ hǎo', :bopomofo => 'ㄋㄧ3 ㄏㄠ3', :yale => 'ni3 hau3', :typy => 'ni3 hao3', :wg => 'ni3 hao3'},#, :ipa => ''}
      { :pyn => 'zhong1 guo2', :py => 'nǐ hǎo', :bopomofo => 'ㄋㄧ3 ㄏㄠ3', :yale => 'ni3 hau3', :typy => 'ni3 hao3', :wg => 'chung1 kuo2'},#, :ipa => ''}
      { :pyn => 'chui1 niu3', :py => '', :bopomofo => '', :yale => 'chwei1 nyou3', :typy => 'chuei1 niou3', :wg => 'chung1 kuo2'},#, :ipa => ''}
    ]
    @str = 'ni3 hao3'
    @mzd = 'Mao2 Ze2 dong1'
    @mzd2 = 'Mao2 Ze2-dong1'
    @py = 'nǐ hǎo'
    @sent = 'Qing3 hui2-da2 wo3 de5 wen4-ti2 .'
    @alabo = {:pyn => 'A1-la1-bo2', :py => 'Ālābó'}
  end
end
