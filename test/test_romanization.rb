# encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'
require 'zhongwen_tools/romanization'
class TestRomanization < Minitest::Test

  def test_romanization_modules
    [:Pinyin, :ZhuyinFuhao, :WadeGiles, :Yale, :TongyongPinyin, :MPS2].each do |module_name|
      assert ZhongwenTools::Romanization.const_defined?(module_name)
    end
  end

  def test_zhuyin_fuhao_method_names
    @romanization_hashes.each do |module_name, method_names|
      rom_module =  ZhongwenTools::Romanization.const_get(module_name)
      singleton_methods = rom_module.singleton_methods
      method_names.map{ |x| "to_#{x}".to_sym }.each do |method_name|
        message = "#{rom_module} should have method called #{ method_name }"
        assert singleton_methods.include?(method_name), message
      end
    end
  end

  def test_split_methods
    @romanizations.each do |romanization|
      length = romanization == @romanizations.last ? 3 : 2

      assert_equal length, ZhongwenTools::Romanization::ZhuyinFuhao.split(romanization[:bpmf]).length
      assert_equal length, ZhongwenTools::Romanization::WadeGiles.split(romanization[:wg]).length
      assert_equal length, ZhongwenTools::Romanization::Yale.split(romanization[:yale]).length
      assert_equal length, ZhongwenTools::Romanization::TongyongPinyin.split(romanization[:typy]).length
      assert_equal length, ZhongwenTools::Romanization::MPS2.split(romanization[:mps2]).length
    end
  end

  def test_zhuyin_fuhao
    type = :bpmf
    @romanizations.each do |romanization|
      assert_equal type, ZhongwenTools::Romanization.romanization?(romanization[type])
      assert_equal romanization[type], ZhongwenTools::Romanization::ZhuyinFuhao.to_bpmf(romanization[:pyn])
      # NOTE: Zhuyin Fuhao doesn't encode capitilization information.
      expected_result = romanization[:pyn].downcase.gsub('-', '')
      py_result = romanization[:py].downcase
      assert_equal expected_result, ZhongwenTools::Romanization::Pinyin::to_pyn(romanization[type])
      assert_equal py_result, ZhongwenTools::Romanization::Pinyin::to_py(romanization[type])
    end
  end

  def test_wade_giles
    type = :wg
    @romanizations.each do |romanization|
      assert ZhongwenTools::Romanization::WadeGiles.wg?(romanization[type])
      assert_equal romanization[type], ZhongwenTools::Romanization::WadeGiles.to_wg(romanization[:pyn])
      expected_result = romanization[:pyn]
      assert_equal expected_result, ZhongwenTools::Romanization::Pinyin::to_pyn(romanization[type], type)
      assert_equal romanization[:py], ZhongwenTools::Romanization::Pinyin::to_py(romanization[type])
    end
  end

  def test_yale
    type = :yale
    @romanizations.each do |romanization|
      assert_equal type, ZhongwenTools::Romanization.romanization?(romanization[type])
      assert_equal romanization[type], ZhongwenTools::Romanization::Yale.to_yale(romanization[:pyn])
      expected_result = romanization[:pyn]
      assert_equal expected_result, ZhongwenTools::Romanization::Pinyin::to_pyn(romanization[type])
      assert_equal romanization[:py], ZhongwenTools::Romanization::Pinyin::to_py(romanization[type])
    end
  end

  def test_tongyong_pinyin
    type = :typy
    @romanizations.each do |romanization|
      assert ZhongwenTools::Romanization::TongyongPinyin.typy?(romanization[type])
      assert_equal romanization[type], ZhongwenTools::Romanization::TongyongPinyin.to_typy(romanization[:pyn])
      expected_result = romanization[:pyn]
      assert_equal expected_result, ZhongwenTools::Romanization::Pinyin::to_pyn(romanization[type], type)
      assert_equal romanization[:py], ZhongwenTools::Romanization::Pinyin::to_py(romanization[type], type)
    end
  end

  def test_mps2
    type = :mps2

    @romanizations.each do |romanization|
      assert ZhongwenTools::Romanization::MPS2.mps2?(romanization[type])
      assert_equal romanization[type], ZhongwenTools::Romanization::MPS2.to_mps2(romanization[:pyn])
      expected_result = romanization[:pyn]
      assert_equal expected_result, ZhongwenTools::Romanization::Pinyin::to_pyn(romanization[type], type)
      assert_equal romanization[:py], ZhongwenTools::Romanization::Pinyin::to_py(romanization[type], type)
    end
  end

  def setup
    @romanization_hashes = {
      ZhuyinFuhao: %w(bpmf zhuyin_fuhao zhuyinfuhao zyfh zhyfh),
      WadeGiles: %w(wg wade_giles),
      Yale: ['yale'],
      TongyongPinyin: %w(typy tongyong tongyong_pinyin),
      MPS2: ['mps2']
    }

    @romanizations = [
      # FIXME: bopomofo, tongyong pinyin, wade-giles tones are all wrong.
      # TODO: test IPA
      {
        pyn: 'ni3 hao3',
        py: 'nǐ hǎo',
        bpmf: 'ㄋㄧ3 ㄏㄠ3',
        yale: 'ni3 hau3',
        typy: 'ni3 hao3',
        wg: 'ni3 hao3',
        mps2: 'ni3 hau3'
      },
      {
        pyn: 'Zhong1guo2',
        py: 'Zhōngguó',
        bpmf: 'ㄓㄨㄥ1ㄍㄨㄛ2',
        yale: 'Jung1gwo2',
        typy: 'Jhong1guo2',
        wg: 'Chung1kuo2',
        mps2: 'Jung1guo2',
      },
      {
        pyn: 'chui1 niu3',
        py: 'chuī niǔ',
        bpmf:  "ㄔㄨㄟ1 ㄋㄧㄡ3",
        yale: "chwei1 nyou3",
        typy: "chuei1 niou3",
        wg: "ch`ui1 niu3",
        mps2: 'chuei1 niou3'
      },
      {
        pyn: 'Mao2 Ze2-dong1',
        py: 'Máo Zédōng',
        bpmf: 'ㄇㄠ2 ㄗㄜ2ㄉㄨㄥ1',
        yale: 'Mau2 Dze2-dung1',
        typy: 'Mao2 Ze2-dong1',
        wg: 'Mao2 Tse2-tung1',
        mps2: 'Mau2 Tze2-dung1'
      }
    ]
  end
end
