#encoding: utf-8
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require './test/test_helper'
require 'zhongwen_tools/conversion'
class String
  include ZhongwenTools::Conversion
  include ZhongwenTools::String
end

class TestConversion < Minitest::Test

  def setup
    @strings = [
      {
        :zhs => '干部一干人等干事不干不净',
        :zht => '幹部一干人等幹事不乾不淨',
        :zhtw => '幹部一干人等幹事不乾不淨',
        :zhhk => '幹部一干人等幹事不乾不淨',
        :zhcn => '干部一干人等干事不干不净'
      },
      {
        :zhs => '线上辞典查询达文西密码',
        :zht => '線上辭典查詢達文西密碼',
        :zhtw => '線上辭典查詢達文西密碼',
        :zhhk => '線上辭典查詢達文西密碼',
        :zhcn => '在线词典查找达芬奇密码'
      },
      {
        :zhs => '嘴里吃着鲔鱼三明治',
        :zht => '嘴裡吃著鮪魚三明治',
        :zhtw => '嘴裡吃著鮪魚三明治',
        :zhhk => '嘴裏吃着吞拿魚三文治',
        :zhcn => '嘴里吃着金枪鱼三明治'
      },
      {
        :zhs => '触摸屏取代鼠标对互联网的影响',
        :zht => '觸摸屏取代鼠標對互聯網的影響',
        :zhtw => '觸控螢幕取代滑鼠對網際網路的影響',
        :zhhk => '觸控螢幕取代滑鼠對互聯網的影響',
        :zhcn => '触摸屏取代鼠标对互联网的影响'
      },
      {
        :zhs => '旧金山台球冠军是谐星',
        :zht => '舊金山檯球冠軍是諧星',
        :zhtw => '舊金山撞球冠軍是諧星',
        :zhhk => '三藩市桌球冠軍是諧星',
        :zhcn => '旧金山台球冠军是笑星'
      }
    ]

  end

  def test_to_zht
    type = :zht
    @strings.each do |zh_hash|
      zh_hash.each do |k, str|
        assert_equal zh_hash[type], ZhongwenTools::Conversion.to_zht(str) , k unless [:zhcn, :zhhk, :zhtw].include? k
      end
    end
  end

  def test_to_zhs
    type = :zhs
    @strings.each do |zh_hash|
      zh_hash.each do |k, str|
        assert_equal zh_hash[type], str.to_zhs , k unless [:zhcn, :zhhk, :zhtw].include? k
      end
    end

  end

  def test_to_zhtw
    type = :zhtw
    @strings.each do |zh_hash|
      zh_hash.each do |k, str|
        assert_equal zh_hash[type], str.to_zhtw , k unless [:zht].include? k
      end
    end

  end

  def test_to_zhhk
    type = :zhhk

    #can only convert tw to hk
    @strings.each do |zh_hash|
      zh_hash.each do |k, str|
        assert_equal zh_hash[type], ZhongwenTools::Conversion.to_zhhk(str) , k unless [:zht, :zhcn].include? k
      end
    end
  end

  def test_to_zhcn
    type = :zhcn
    @strings.each do |zh_hash|
      zh_hash.each do |k, str|
        assert_equal zh_hash[type], ZhongwenTools::Conversion.to_zhcn(str) , k unless [:zhs ].include? k
      end
    end
  end

  def test_zhs?
    @strings.each do |zh_hash|
      assert zh_hash[:zhcn].zhs?
      assert zh_hash[:zhs].zhs?
      refute zh_hash[:zht].zhs?
      refute zh_hash[:zhtw].zhs?
      refute zh_hash[:zhhk].zhs?
    end
  end

  def test_zht?
    @strings.each do |zh_hash|
      refute zh_hash[:zhcn].zht?
      refute zh_hash[:zhs].zht?
      assert zh_hash[:zht].zht?
      assert zh_hash[:zhtw].zht?
      assert zh_hash[:zhhk].zht?, zh_hash[:zhhk]
    end
  end

end
