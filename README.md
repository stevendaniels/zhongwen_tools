#Zhongwen Tools:
Methods for dealing with Chinese.

[![Build
Status](https://travis-ci.org/stevendaniels/zhongwen_tools.png?branch=master)](https://travis-ci.org/stevendaniels/zhongwen_tools) [![Dependency Status](https://gemnasium.com/stevendaniels/zhongwen_tools.png)](https://gemnasium.com/stevendaniels/zhongwen_tools) [![Code Climate](https://codeclimate.com/github/stevendaniels/zhongwen_tools.png)](https://codeclimate.com/github/stevendaniels/zhongwen_tools) [![Coverage Status](https://coveralls.io/repos/stevendaniels/zhongwen_tools/badge.png)](https://coveralls.io/r/stevendaniels/zhongwen_tools)
[![Gem Version](https://badge.fury.io/rb/zhongwen_tools.png)](http://badge.fury.io/rb/zhongwen_tools)

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

    '你好'.uri_encode

    '你好'.uri_escape

    '你好！'.strip_zh_punctuation #=> '你好'

    'hello'.ascii?

    '你好'.multibyte?

    'hello'.halfwidth?

    'ｈeｌｌｏ'.fullwidth?
    
    'ｈeｌｌｏ'.to_halfwidth?

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

##TODO:
 1. create a generic ZhongwenTools::Romanization.split method for convenience
