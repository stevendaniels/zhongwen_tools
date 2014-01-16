#Zhongwen Tools: tools and methods for dealing with Chinese.


##INSTALLATION

Install as a gem

    $ [sudo] gem install zhongwen_tools

## Usage

Add the ZhongwenTools component you need to your classes as a module.

    class String
      include ZhongwenToolsRomanization
    end

    str = "ni3 hao3"  #pinyin with numbers
    str.to_pinyin     #=> "nǐ hǎo"
    str.to_zhuyinfuhao  #=>

    mzd = "Mao Tse-tung"
    mzd.to_pinyin   #=> Mao Zedong

Or you can require the components you want
    require 'zhongwen_tools/numbers'
    ZhongwenTools::Numbers.to_pinyin '一百二十' #=> 'yi1-bai2-er4-shi2'

ZhongwenTools includes the following modules:
1. ZhongwenTools::String => some useful string functions and functions for identifying Chinese scripts and romanizations.
2. ZhongwenTools::Numbers => functions for identifying and converting numbers.
3. ZhongwenTools::Integer => some useful integer functions for Chinese:
   e.g. 12.to_pinyin 12.to_zht
4. ZhongwenTools::Romanization => functions for converting between Chinese romanization systems
5. ZhongwenTools::Conversion => functions for converting between Chinese scripts.
6. ZhongwenTools::ToneSandhi => functions for identifying and dealing with tone sandhi. (Wiki URL)
7. [TODO] ZhongwenTools::Segmentation => functions for segmenting Chinese. Can provide different methods for converting
8. ZhongwenTools::Tagging => functions for tagging Chinese POS, NER, etc.
  
  
### ZhongwenTools::String: useful string functions for ZhongwenTools language
    ZhongwenTools::String.ascii? 'hello'    #=> true #non-multibyle strings
    ZhongwenTools::String.multibyte? '中文  #=> true #multibtye strings
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

#### ruby 1.8 safe methods 
    ZhongwenTools::String.chars '中文' #=> ['中','文']
    ZhongwenTools::String.size '中文'  #=> 2
    ZhongwenTools::String.reverse '中文' #=> '文中'
    ZhongwenTools::Unicode.to_utf8 '\x{D6D0}\x{CEC4}' => '中文'


###Numbers
Functions for converting to and from Chinese numbers.

###Integers

### Romanization
ZhongwenTools::Chinese has tools for converting between Chinese language romanization systems and
scripts.

    class String
      include ZhongwenToolsRomanization
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

ZhongwenTools::Conversion.to_zhs
ZhongwenTools::Conversion.to_zht
ZhongwenTools::Conversion.to_zhtw
ZhongwenTools::Conversion.to_zhhk
ZhongwenTools::Conversion.to_zhmc
ZhongwenTools::Conversion.to_zhsg
ZhongwenTools::Conversion.to_zhprc


###Tone Sandhi
Some functions for predicting / converting to tone sandhi

##Plugins
Zhongwen Tools tries to avoid having many dependencies. Functionality
that requires an external dependency is packaged as a separate gem.

## TODO
1. A trad/simp script converter
2. A character -> pinyin converter
3. A language detector
