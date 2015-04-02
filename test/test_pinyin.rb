# encoding: utf-8
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require './test/test_helper'
require 'zhongwen_tools/romanization/pinyin'
class TestPinyin < Minitest::Test
  def test_split_pyn
    @split_words.each do |w|
      assert_equal w[:split], ZhongwenTools::Romanization::Pinyin.split_pyn(w[:pyn])
    end
  end

  def test_split_py
    @split_words.each do |w|
      assert_equal w[:split_py], ZhongwenTools::Romanization::Pinyin.split_py(w[:py])
    end

    assert_equal ['fǎn', 'guāng', 'jìng'], ZhongwenTools::Romanization::Pinyin.split_py('fǎnguāngjìng')
    assert_equal ['Yīng', 'guó'], ZhongwenTools::Romanization::Pinyin.split_py('Yīngguó')
  end

  def test_py?
    @words.each do |w|
      assert ZhongwenTools::Romanization::Pinyin.py?(w[:py]), w.inspect
      refute ZhongwenTools::Romanization::Pinyin.py?(w[:pyn]), w.inspect
    end

    @syllabic_nasals.each do |w|
      assert ZhongwenTools::Romanization::Pinyin.py?(w[:py]), w.inspect
    end

    assert ZhongwenTools::Romanization::Pinyin.py? 'fǎnguāngjìng'

    english_words = %w(cyan moose cling touch)

    english_words.each do |w|
      refute ZhongwenTools::Romanization::Pinyin.py?(w), w
    end
  end

  def test_pyn?
    @words.each do |w|
      refute ZhongwenTools::Romanization::Pinyin.pyn?(w[:py]), w.inspect
      assert ZhongwenTools::Romanization::Pinyin.pyn?(w[:pyn]), w.inspect
    end

    assert ZhongwenTools::Romanization::Pinyin.pyn?('ma2-fan')
    assert ZhongwenTools::Romanization::Pinyin.pyn?('yo1')
  end

  def test_syllabic_nasal_pyn?
    assert ZhongwenTools::Romanization::Pinyin.pyn?('ng3')
    assert ZhongwenTools::Romanization::Pinyin.pyn?('m3')
    assert ZhongwenTools::Romanization::Pinyin.pyn?('n3')
  end

  def test_pyn_to_pinyin
    [@hyphenated_words, @words].flatten.each do |word|
      assert_equal word[:py], ZhongwenTools::Romanization::Pinyin.to_pinyin(word[:pyn])
      assert_equal word[:py], ZhongwenTools::Romanization::Pinyin.to_py(word[:pyn])
    end

    @syllabic_nasals.each do |word|
      assert_equal word[:py], ZhongwenTools::Romanization::Pinyin.to_pinyin(word[:pyn])
      assert_equal word[:py], ZhongwenTools::Romanization::Pinyin.to_py(word[:pyn])
    end
  end

  def test_pinyin_to_pyn
    @words.each do |word|
      assert_equal word[:pyn], ZhongwenTools::Romanization::Pinyin.to_pyn(word[:py])
    end

    @syllabic_nasals.each do |word|
      assert_equal word[:pyn], ZhongwenTools::Romanization::Pinyin.to_pyn(word[:py]), word
    end

    assert_equal 'yi2ge4', ZhongwenTools::Romanization::Pinyin.to_pyn('yígè')
    assert_equal 'yi4nian2', ZhongwenTools::Romanization::Pinyin.to_pyn('yìnián', :py)
  end

  def setup
    @hyphenated_words = [
      { :pyn => 'A1-la1-bo2', :py => 'Ālābó' },
      { :pyn => 'Mao2 Ze2-dong1', :py => 'Máo Zédōng' }
    ]

    @split_words = [
      { :pyn => 'A1-la1-bo2',  :py => 'Ālābó', :split => %w(A1 la1 bo2), split_py: %w(Ā lā bó) },
      { :pyn => 'Mao2 Ze2-dong1',  :py => 'Máo Zédōng', :split => %w(Mao2 Ze2 dong1), :split_py =>  %w(Máo Zé dōng) }
    ]

    @syllabic_nasals = [
      { pyn: 'ng3', py: 'ňg'},
      { pyn: 'm3', py: 'm̌'},
      { pyn: 'n3', py: 'ň'},
      { pyn: 'Ng3', py: 'Ňg'}
    ]

    @words = [
      { pyn: 'A1la1bo2', py: 'Ālābó'},
      { pyn: 'ni3 hao3', py: 'nǐ hǎo' },
      { pyn: 'Zhong1guo2', py: 'Zhōngguó' },
      { pyn: 'chui1 niu3', py: "chuī niǔ" },
      { pyn: 'Mao2 Ze2dong1', py: 'Máo Zédōng' }
    ]

    @r =  { pyn: 'r5', py: 'r' }
  end
end
