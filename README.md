#Zhongwen Tools:
Tools and methods for dealing with Chinese.

[![Build
Status](https://travis-ci.org/stevendaniels/zhongwen_tools.png?branch=master)](https://travis-ci.org/stevendaniels/zhongwen_tools) [![Dependency Status](https://gemnasium.com/stevendaniels/zhongwen_tools.png)](https://gemnasium.com/stevendaniels/zhongwen_tools) [![Code Climate](https://codeclimate.com/github/stevendaniels/zhongwen_tools.png)](https://codeclimate.com/github/stevendaniels/zhongwen_tools) [![Coverage Status](https://coveralls.io/repos/stevendaniels/zhongwen_tools/badge.png)](https://coveralls.io/r/stevendaniels/zhongwen_tools)
[![Gem Version](https://badge.fury.io/rb/zhongwen_tools.png)](http://badge.fury.io/rb/zhongwen_tools)

##INSTALLATION

Install as a gem

    $ [sudo] gem install zhongwen_tools


Zhongwen Tools is a set of modules that makes working with Chinese
easier. It includes the following:

1. ZhongwenTools::String - deals with strings that are Chinese or pinyin.
2. ZhongwenTools::Numbers - identifies Chinese numbers and converts numbers to and from Chinese.
3. ZhongwenTools::Integer - converts integers into Chinese or pinyin.
4. ZhongwenTools::Romanization - converts converting between Chinese romanization systems like Pinyin and Wade-Giles.
5. ZhongwenTools::Conversion - converts between Chinese scripts.



## Usage

Add the ZhongwenTools component you need to your classes as a module.

    require 'zhongwen_tools/romanization'

    class String
      include ZhongwenTools::Romanization
    end

    str = 'ni3 hao3'  #pinyin with numbers
    str.to_pinyin
    #=> 'nǐ hǎo'

    str.to_zhuyin_fuhao
    #=> 'ㄋㄧ3 ㄏㄠ3'

    mzd = 'Mao Tse-tung'
    mzd.to_pinyin
    #=> 'Mao Zedong'

Or require the components you want.

    require 'zhongwen_tools/numbers'

    ZhongwenTools::Numbers.to_pyn '一百二十'
    #=> 'yi1-bai2-er4-shi2'

### Using ZhongwenTools::String
Zhongwen Tools has string methods for detecting different string formats
and for converting to and from halfwidth, fullwidth, and utf-8 codepoints.

    require 'zhongwen_tools/string'

    ZhongwenTools::String.ascii? 'hello'
    #=> true #non-multibyle strings

    ZhongwenTools::String.multibyte? '中文'
    #=> true #multibtye strings

    ZhongwenTools::String.halfwidth? 'hello'
    #=> true

    ZhongwenTools::String.fullwidth? 'ｈｅｌｌｏ'
    #=> true

    ZhongwenTools::String.to_halfwidth 'ｈｅｌｌｏ'
    #=> 'hello'

    ZhongwenTools::String.uri_encode '我太懒'
    #=> '%E6%88%91%E5%A4%AA%E6%87%92'

    ZhongwenTools::String.to_codepoint '中文'
    #=> '\u4e2d\u6587'

    ZhongwenTools::String.from_codepoint '\u4e2d\u6587'
    #=> '中文' #converts string from a utf-8 codepoint.


#### Detecting Chinese or Chinese Punctuation.
Zhongwen Tools can also detect if a string is or has Chinese or Chinese
punctuation.

	require 'zhongwen_tools/string'
    ZhongwenTools::String.has_zh? '1月'
    #=> true

    ZhongwenTools::String.zh? '1月'
    #=> false #(The string can't be mixed.)

    ZhongwenTools::String.has_zh_punctuation? '你在哪里？'
    #=> true
    ZhongwenTools::String.strip_zh_punctuation? '你在哪里？'
    #=> '你在哪里'

#### Converting between Traditional and Simplified Chinese
By requiring conversion module, ZhongwenTools::String gets some
convenience methods for converting to and from traditional and
simplified Chinese.

    require 'zhongwen_tools/conversion'

    ZhongwenTools::String.zhs? '中国'
    #=> true
    ZhongwenTools::String.zht? '中国'
    #=> false

#### Romanization
By requiring the romanization module ZhongwenTools::String gets some
convenience methods for dealing with romanization.

    require 'zhongwen_tools/romanziation'

    ZhongwenTools::String.to_pinyin 'ni3 hao3'
    #=> 'nǐ hǎo'


#### Pinyin-safe String Methods
The following capitalization methods work for pinyin.

    require 'zhongwen_tools/string'

    ZhongwenTools::String.downcase 'Àomén'
    #=> 'àomén' does pinyin/ lowercase
    ZhongwenTools::String.upcase 'àomén'
    #=> 'ÀOMÉN'
    ZhongwenTools::String.capitalize 'àomén'
    #=> 'Àomén'


### Numbers
Functions for converting to and from Chinese numbers.

    require 'zhongwen_tools/numbers'

    ZhongwenTools::Numbers.number_to_zht :num, 12000
    #=> '一萬二千'
    ZhongwenTools::Numbers.number_to_zhs :num, 42
    #=> '四十二'
    ZhongwenTools::Numbers.number_to_pyn :num, 42
    #=> 'si4-shi2-er4'
    ZhongwenTools::Numbers.zh_number_to_number '四十二'
    #=> 42
    ZhongwenTools::Numbers.number? '四十二'
    #=> true

### Integers
Monkey-patch your integers for Chinese.

    require 'zhongwen_tools/ingteger'

    class Integer
      include ZhongwenTools::Integer
    end

    12.to_pinyin
    #=> 'shi2-er4'
    12.to_zht
    #=> '十二'


### Romanization
ZhongwenTools::Romanization has tools for converting between Chinese language romanization systems and
scripts. It **does not convert Chinese characters to pinyin** (see ZhongwenTools::Conversion). Romanization methods must be required explicitly.

    gem 'zhongwen_tools'
    require 'zhongwen_tools/romanization'

    class String
      include ZhongwenTools::Romanization
    end


    str = 'ni3 hao3'
    py = 'nǐ hǎo'

    str.to_pinyin
    #=> 'nǐ hǎo'
    str.to_py
    #=> 'nǐ hǎo'

    py.to_pyn
    #=> 'ni3 hao3'

    str.to_wg
    #=> 'ni3 hao3'    #Wade-Giles
    
    str.to_bpmf
    #=> 'ㄋㄧ3 ㄏㄠ3' #Zhuyin Fuhao, a.k.a. Bopomofo

    str.to_yale
    #=> 'ni3 hau3'

    str.to_typy
    #=> 'ni3 hao3'

    str.pyn?
    #=> true
    str.wg?
    #=> true #(There can be overlap between Wade-Giles and Pinyin)
    str.to_py.py? 
    #=> true

    #split pinyin with numbers accurately.
    'dong1xi1'.split_pyn    # => ['dong1', 'xi1']
    'dongxi'.split_pyn      # => ['dong', 'xi']

### Conversion
Functions for converting between scripts (e.g. traditional Chinese to
simplified Chinese) and [TODO] between Chinese and romanization systems (e.g.
Chinese to pinyin).
Conversion methods must be required explicitly.

    gem 'zhongwen_tools'
    require 'zhongwen_tools/conversion'

    ZhongwenTools::Conversion.to_zhs '華語'
    #=> '华语'
    ZhongwenTools::Conversion.to_zht '华语'
    #=> '華語'
    ZhongwenTools::Conversion.to_zhtw '方便面'
    #=> '泡麵'
    ZhongwenTools::Conversion.to_zhhk '方便面'
    #=> '即食麵'
    ZhongwenTools::Conversion.to_zhcn '即食麵'
    #=> '方便面'


## TODO
1. A character -> pinyin converter
