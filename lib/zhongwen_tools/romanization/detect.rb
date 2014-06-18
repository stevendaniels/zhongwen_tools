# encoding: utf-8
require 'zhongwen_tools/regex'

module ZhongwenTools
  module Romanization
    extend self
    # Deprecated: a Regex for accurate pinyin. Use ZhongwenTools::Regex.py instead
    PY_REGEX = ZhongwenTools::Regex.py

    # Deprecate: a Regex for accurate pinyin with numbers. use ZhongwenTools::Regex.pyn instead.
    PINYIN_REGEX = ZhongwenTools::Regex.pyn

    # Public: checks if a string is pinyin.
    #         http://en.wikipedia.org/wiki/Pinyin
    #
    # Examples
    #   py?('nǐ hǎo')
    #   # => true
    #
    # Returns Boolean.
    def py?(str = nil)
      str ||= self

      # NOTE: py regex does not include capitals with tones.
      String.downcase(str).gsub(Regex.punc,'').gsub(Regex.py, '').gsub(/[\s\-]/,'').strip == ''
    end

    # Public: checks if a string is pinyin.
    #
    # Examples
    #   pyn?('pin1-yin1')
    #   # => true
    #
    # Returns Boolean.
    def pyn?(str = nil)
      str ||= self

      str.gsub(Regex.punc,'').gsub(Regex.pyn, '').gsub(/[\s\-]/,'').strip == ''
    end

    # Public: Checks if a String is Zhuyin Fuhao (a.k.a. bopomofo).
    #         http://en.wikipedia.org/wiki/Bopomofo
    #         http://pinyin.info/romanization/bopomofo/index.html
    #
    # str - a String. Optional if the object calling the method is a String.
    #
    # Examples
    #
    #   bpmf?('ㄊㄥ')
    #   # => true
    #
    # Returns a boolean.
    def bpmf?(str = nil)
      str ||= self

      bopomofo = str.gsub(/[1-5\s]/,'').gsub(Regex.punc,'')
      bopomofo.scan(Regex.bopomofo).join == bopomofo
    end

    # Public: Checks if a String is a romanization:
    #         Tongyong Pinyin, Wade Giles, MSP2 or Yale.
    #         http://en.wikipedia.org/wiki/Tongyong_Pinyin
    #         http://pinyin.info/romanization/tongyong/
    #         http://en.wikipedia.org/wiki/Wade%E2%80%93Giles
    #
    # str - a String. Optional if the object calling the method is a String.
    #
    # Examples
    #
    #   typy?('chuei niou')
    #   # => true
    #   wg?('Mao2 Tse2 Tung1')
    #
    # Returns a boolean.
    %w(typy wg yale mps2).each do |type|
      define_method("#{type}?") do |str = nil|
        str ||= self
        # TODO: ignore tonal marks from other systems wade giles, tongyong etc.
        s = str.downcase.gsub(Regex.punc,'').gsub(/[1-5\s\-']/,'')

        s.scan(detect_regex(type.to_sym)).join == s
      end
    end

    # Public: Checks the srings romanizaiton. It always assumes the first correct result is the correct result.
    #         This can sometimes provide sub-optimal results
    #         e.g.
    #           'chuei niou'.romanization? #=> :pyn
    #           'chuei niou'.pyn? == true # this is correct because ['chu', 'ei', 'ni', 'ou'] are all valid pinyin
    #                                     # but the best fit for 'chuei niou' should be :typy.
    #         But this is not considered a major issue because most of the time pyn / py will be used. It could be
    #         extended to try and figure out the best option, maybe by comparing the syllable length of each
    #         valid romanization.
    #
    # str - a String. Optional if the object calling the method is a String.
    #
    # Examples
    #
    #
    #   'hao3'.romanization? #=> :pyn
    #
    # Returns a Symbol for the romanization type.
    def romanization?(str = nil)
      str ||= self

      [:pyn, :py, :zyfh, :wg, :typy, :yale, :mps2].find do |type|
        self.send("#{type}?", str)
      end
    end

    # TODO: romanizations? method that returns all possible romanizations.

    # Deprecated: ZhongwenTools::Romanizaiton.zyfh? is deprecated. Use ZhongwenTools::Romanizaiton.bpmf? instead
    alias_method :zyfh?, :bpmf?

    private

    # Internal: Produces a Regexp for a romanization type.
    #
    # type - a Symbol for the romanization type.
    #
    # Examples:
    #
    #
    #   detect_regex(:typy) #=> <Regexp>
    #
    # Returns a Regexp.
    def detect_regex(type)
      /#{regex_values(type).sort{|x,y| x.size <=> y.size}.reverse.join('|')}/
    end

    def regex_values(type)
      ROMANIZATIONS_TABLE.map{ |r| "[#{r[type][0]}#{r[type][0].upcase}]#{r[type][1..-1]}" || r[:pyn] }.flatten
    end
  end
end
