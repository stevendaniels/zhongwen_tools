#Zhongwen Tools:
Methods for dealing with Chinese.

[![Build Status](https://img.shields.io/travis/stevendaniels/zhongwen_tools.svg?style=flat-square)](https://travis-ci.org/stevendaniels/zhongwen_tools) 
[![Maintainability](https://api.codeclimate.com/v1/badges/90b5794e9cc3a3b4207d/maintainability)](https://codeclimate.com/github/stevendaniels/zhongwen_tools/maintainability)
[![Coverage Status](https://img.shields.io/coveralls/stevendaniels/zhongwen_tools.svg?style=flat-square)](https://coveralls.io/r/stevendaniels/zhongwen_tools)
[![Gem Version](https://img.shields.io/gem/v/zhongwen_tools.svg?style=flat-square)](http://badge.fury.io/rb/zhongwen_tools)

##INSTALLATION

Install as a gem

    $ [sudo] gem install zhongwen_tools


## Usage

You can monkey patch the String class or use refinements (Ruby 2.0+).

### Monkey Patch

You can monkey patch the String class.

    require 'zhongwen_tools'
    require 'zhongwen_tools/core_ext/string'

    # normalizes the behavior between Ruby 1.9.2, 1.9.3, 2+
    '中国'chars #=> ['中', '国']

    'zhōngguó'.capitalize #=> 'Zhōngguó'

    'Zhōngguó'.zh_downcase #=> 'zhōngguó'

    'ālābó'.zh_upcase #=> 'ĀLĀBÓ'

    '你好Kailin！'.has_zh? # => true

    '你好Kailin！'.has_zh_punctuation? # => true

    '你好'.zh? #=> true

    '你好'.uri_encode #=> "%E4%BD%A0%E5%A5%BD"

    '你好'.uri_escape #=> "%E4%BD%A0%E5%A5%BD"

    '你好！'.strip_zh_punctuation #=> '你好'

    'hello'.ascii?  #=> true

    '你好'.multibyte? #=> true

    'hello'.halfwidth?  #=> false

    'ｈeｌｌｏ'.fullwidth?  #=> true

    'ｈeｌｌｏ'.to_halfwidth? #=> 'hello'

    '\u4e2d\u6587'.from_codepoint #=> '中文'

    '中文'.to_codepoint #=>  '\u4e2d\u6587'

    'Zhong1guo2'.to_pinyin #=> 'Zhōngguó'

    'Zhong1guo2'.to_py #=> 'Zhōngguó'

    'Zhōngguó'.to_py #=> 'Zhong1guo2'

    'nǐ hǎo'.to_bpmf #=> 'ㄋㄧ3 ㄏㄠ3'

    'nǐ hǎo'.to_zyfh #=> 'ㄋㄧ3 ㄏㄠ3'

    'nǐ hǎo'.to_zhyfh #=> 'ㄋㄧ3 ㄏㄠ3'

    'nǐ hǎo'.to_bopomofo #=> 'ㄋㄧ3 ㄏㄠ3'

    'nǐ hǎo'.to_yale #=> 'ni3 hau3',

    'nǐ hǎo'.to_typy #=> 'ni3 hao3',

    'nǐ hǎo'.to_tongyong #=> 'ni3 hao3',

    'nǐ hǎo'.to_tongyong_pinyin #=> 'ni3 hao3',

    'nǐ hǎo'.to_wg #=> 'ni3 hao3',

    'nǐ hǎo'.to_wade_giles #=> 'ni3 hao3',

    'nǐ hǎo'.to_mps2 #=> 'ni3 hau3'

    'nǐ hǎo'.romanization? :py

    'nǐ hǎo'.py? #=> true

    'nǐ hǎo'.pyn? # false

    'nǐ hǎo'.bpmf? # false

    'nǐ hǎo'.wg? # false

    'nǐ hǎo'.yale? # false

    'nǐ hǎo'.typy? # false

    'nǐ hǎo'.mps2? # false

    '你们好'.zhs? #=> true

    '你们好'.zht? #=> false

    '你們好'.to_zhs #=> '你们好'

    '你们好'.to_zht #=> '你們好'

    '金枪鱼'.to_zhtw #=> '鮪魚'

    '鮪魚'.to_zhcn #=> '金枪鱼'

    '金枪鱼'.to_zhhk #=> '吞拿魚'

#### Integer Extensions

You can also monkey patch the Integer class!
    require 'zhongwen_tools'
    require 'zhongwen_tools/core_ext/integer'

    1.to_pyn #=> 'yi1'
    10_000.to_zht #=> '一萬'
    10_000.to_zhs #=> '一万'

### Refinements (Ruby > 2.0 only)

You can also use refinements, to refine the string or integer class.

    # some_class.rb
    require 'zhongwen_tools'
    using ZhongwenTools

    class SomeClass

      def hi
        '你们好'.to_zht
      end
    end

    SomeClass.new.hi #=> 你們好

### ZhongwenTools::Core

The core functionality of ZhongwenTools excludes converting between
simplified and traditional Chinese. You can use it by requiring
'zhongwen_tools/core' instead of 'zhongwen_tools'

    require 'zhongwen_tools/core'
    require 'zhongwen_tools/core_ext/string'

    'ni3 hao3'.to_pinyin #=> 'nǐ hǎo'
    '你們好'.to_zhs #=> NoMethodError
