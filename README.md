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

ZhongwenTools includes the following modules:

1. ZhongwenTools::String => some useful string functions and functions for identifying Chinese scripts and romanizations.
2. ZhongwenTools::Numbers => functions for identifying and converting numbers.
3. ZhongwenTools::Integer => some useful integer functions for Chinese:
4. ZhongwenTools::Romanization => functions for converting between Chinese romanization systems
5. [TODO] ZhongwenTools::Conversion => functions for converting between Chinese scripts.
6. [TODO] ZhongwenTools::ToneSandhi => functions for identifying and dealing with tone sandhi. (Wiki URL)
7. [TODO] ZhongwenTools::Segmentation => functions for segmenting Chinese. Can provide different methods for converting
8. [TODO] ZhongwenTools::Tagging => functions for tagging Chinese POS, NER, etc.


### ZhongwenTools::String: useful string functions for Chinese.
    ZhongwenTools::String.ascii? 'hello'    #=> true #non-multibyle strings
    ZhongwenTools::String.multibyte? '中文'  #=> true #multibtye strings
    ZhongwenTools::String.halfwidth?
    ZhongwenTools::String.fullwidth?
    ZhongwenTools::String.to_halfwidth
    ZhongwenTools::String.uri_encode  #=> just because I'm lazy
    ZhongwenTools::Unicode.to_codepoint
    ZhongwenTools::Unicode.to_unicode --> converts from unicode codepoint.
    ZhongwenTools::String.downcase --> does pinyin/ lowercase
    ZhongwenTools::String.upcase --> does pinyin uppercase
    ZhongwenTools::String.capitalize ---> does pinyin / fullwidth capitalization

    ZhongwenTools::String.has_zh? '1月'     #=> true
    ZhongwenTools::String.is_zh? '1月'      #=> false can't be mixed.
    ZhongwenTools::String.is_zhs? '中国'    #=> true
    ZhongwenTools::String.is_zht? '中国'    #=> false

#### Ruby 1.8 safe methods
    ZhongwenTools::String.chars '中文' #=> ['中','文']
    ZhongwenTools::String.size '中文'  #=> 2
    ZhongwenTools::String.reverse '中文' #=> '文中'
    ZhongwenTools::Unicode.to_utf8 '\x{D6D0}\x{CEC4}' => '中文'


###Numbers
Functions for converting to and from Chinese numbers.

    ZhongwenTools::Number.number_zht 12000        #=> '一萬二千'
    ZhongwenTools::Number.number_zhs 42           #=> '四十二'
    ZhongwenTools::Number.number_to_pyn 42        #=> 'si4-shi2-er4'
    ZhongwenTools::Number.number_to_int '四十二'  #=> 42
    ZhongwenTools::Number.number? '四十二'        #=> true

###Integers
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

    str.to_pinyin romanization_system
    #=> "nǐ hǎo"

    str.to_py romanization_system
    #=> "nǐ hǎo"

    str.to_pyn
    #=> "ni3 hao3"

    str.to_wg
    str.to_bpmf
    str.to_yale
    str.to_typy
    str.to_msp3
    str.to_tone_sandhi   #=> converts pinyin into it's spoken tones.
    #=> "ni2 hao3"
    str.tone_sandhi?     #=> checks if the word has tone sandhi
    #=> true
    str.romanization?

### Conversion
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

##Plugins
Zhongwen Tools tries to avoid having many dependencies. Functionality
that requires an external dependency is packaged as a separate gem.

## TODO
1. A trad/simp script converter
2. A character -> pinyin converter
