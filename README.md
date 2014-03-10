#Zhongwen Tools:
Tools and methods for dealing with Chinese.

[![Build
Status](https://travis-ci.org/stevendaniels/zhongwen_tools.png?branch=master)](https://travis-ci.org/stevendaniels/zhongwen_tools) [![Dependency Status](https://gemnasium.com/stevendaniels/zhongwen_tools.png)](https://gemnasium.com/stevendaniels/zhongwen_tools) [![Code Climate](https://codeclimate.com/github/stevendaniels/zhongwen_tools.png)](https://codeclimate.com/github/stevendaniels/zhongwen_tools) [![Coverage Status](https://coveralls.io/repos/stevendaniels/zhongwen_tools/badge.png)](https://coveralls.io/r/stevendaniels/zhongwen_tools)
[![Gem Version](https://badge.fury.io/rb/zhongwen_tools.png)](http://badge.fury.io/rb/zhongwen_tools)

##INSTALLATION

Install as a gem

    $ [sudo] gem install zhongwen_tools

## Usage

Add the ZhongwenTools component you need to your classes as a module.

    class String
      include ZhongwenTools::Romanization
    end

    str = "ni3 hao3"  #pinyin with numbers
    str.to_pinyin     #=> "nǐ hǎo"
    str.to_zhuyinfuhao  #=>

    mzd = "Mao Tse-tung"
    mzd.to_pinyin   #=> "Mao Zedong"

Or you can require the components you want

    require 'zhongwen_tools/numbers'
    ZhongwenTools::Numbers.to_pyn '一百二十' #=> 'yi1-bai2-er4-shi2'

ZhongwenTools includes the following Modules:

1. ZhongwenTools::String - methods for dealing with strings with Chinese and pinyin.
2. ZhongwenTools::Numbers - methods for identifying Chinese numbers and for converting to and from Chinese.
3. ZhongwenTools::Integer - methods for converting integers into Chinese or pinyin.
4. ZhongwenTools::Romanization - methods for converting between Chinese romanization systems.
5. [TODO] ZhongwenTools::Conversion => functions for converting between Chinese scripts.
6. [TODO] ZhongwenTools::ToneSandhi => functions for identifying and dealing with tone sandhi. (Wiki URL)
7. [TODO] ZhongwenTools::Segmentation => functions for segmenting Chinese. Can provide different methods for converting
8. [TODO] ZhongwenTools::Tagging => functions for tagging Chinese POS, NER, etc.


### Using ZhongwenTools::String
    require 'zhongwen_tools/string'
    ZhongwenTools::String.ascii? 'hello'              #=> true #non-multibyle strings
    ZhongwenTools::String.multibyte? '中文'            #=> true #multibtye strings
    ZhongwenTools::String.halfwidth? 'hello'          #=> true
    ZhongwenTools::String.fullwidth? 'ｈｅｌｌｏ'       #=> true
    ZhongwenTools::String.to_halfwidth 'ｈｅｌｌｏ'     #=> 'hello'

    ZhongwenTools::String.uri_encode '我太懒'             #=> '%E6%88%91%E5%A4%AA%E6%87%92'
    ZhongwenTools::String.to_codepoint '中文'            #=> '\u4e2d\u6587'
    ZhongwenTools::String.from_codepoint '\u4e2d\u6587' #=> '中文' #converts string from a utf-8 codepoint.

    ZhongwenTools::String.has_zh? '1月'     #=> true
    ZhongwenTools::String.zh? '1月'      #=> false #(The string can't be mixed.)
    #TODO: ZhongwenTools::String.zhs? '中国'    #=> true
    #TODO: ZhongwenTools::String.zht? '中国'    #=> false

    ZhongwenTools::String.has_zh_punctuation? '你在哪里？'    #=> true
    ZhongwenTools::String.strip_zh_punctuation? '你在哪里？'  #=> '你在哪里'

#### The following capitalization methods work for pinyin.
    require 'zhongwen_tools/string'
    ZhongwenTools::String.downcase 'Àomén'  #=> 'àomén' does pinyin/ lowercase
    ZhongwenTools::String.upcase 'àomén'    #=> --> does pinyin uppercase
    ZhongwenTools::String.capitalize 'àomén'  #=> 'Àomén'

#### Ruby 1.8 safe methods
Zhongwen Tools is tested on every ruby since 1.8.7 and lets you deal
with multibyte strings in an simple way.
    require 'zhongwen_tools/string'
    ZhongwenTools::String.chars '中文' #=> ['中','文']
    ZhongwenTools::String.size '中文'  #=> 2
    ZhongwenTools::String.reverse '中文' #=> '文中'
    ZhongwenTools::String.to_utf8 '\x{D6D0}\x{CEC4}' => '中文'


### Numbers
Functions for converting to and from Chinese numbers.

    ZhongwenTools::Number.number_zht 12000        #=> '一萬二千'
    ZhongwenTools::Number.number_zhs 42           #=> '四十二'
    ZhongwenTools::Number.number_to_pyn 42        #=> 'si4-shi2-er4'
    ZhongwenTools::Number.number_to_int '四十二'  #=> 42
    ZhongwenTools::Number.number? '四十二'        #=> true

### Integers
Monkey-patch your integers for Chinese.

    class Integer
      include ZhongwenTools::Integer
    end

    12.to_pinyin #=> 'shi2-er4'
    12.to_zht    #=> '十二'


### Romanization
ZhongwenTools::Romanization has tools for converting between Chinese language romanization systems and
scripts. It **does not convert Chinese characters to pinyin** (see ZhongwenTools::Conversion). 

    class String
      include ZhongwenTools::Romanization
    end


    str = "ni3 hao3"
    romanization_system = "pyn" #pyn|wg|yale|bpmf|zhyfh|wade-giles|bopomofo

    str.to_pinyin     #=> "nǐ hǎo"
    str.to_py         #=> "nǐ hǎo"
    str.to_pyn       #=> "ni3 hao3"

    str.to_wg       #=> "ni3 hao3"    #Wade-Giles
    str.to_bpmf     #=> "ㄋㄧ3 ㄏㄠ3" #Zhuyin Fuhao, a.k.a. Bopomofo
    str.to_yale     #=> "ni3 hau3"
    str.to_typy

    #converts pinyin into it's spoken tones.
    #TODO: str.to_tone_sandhi     #=> "ni2 hao3"

    #checks if the word has tone sandhi
    str.tone_sandhi?      #=> true

    #TODO: str.romanization?
    str.pyn? #=> true
    str.wg?  #=> true #(There can be overlap between Wade-Giles and Pinyin)


### Conversion [TODO]
Functions for converting between scripts (e.g. traditional Chinese to
simplified Chinese) and between chinese and romanization systems (e.g.
Chinese to pinyin).

    ZhongwenTools::Conversion.to_zhs ‘華語'
    ZhongwenTools::Conversion.to_zht '华语'
    ZhongwenTools::Conversion.to_zhtw '方便面'
    ZhongwenTools::Conversion.to_zhhk '方便面'
    ZhongwenTools::Conversion.to_zhmc
    ZhongwenTools::Conversion.to_zhsg
    ZhongwenTools::Conversion.to_zhprc '马铃薯'


###Tone Sandhi
Some functions for predicting / converting to tone sandhi


## TODO
1. A trad/simp script converter
2. A character -> pinyin converter
