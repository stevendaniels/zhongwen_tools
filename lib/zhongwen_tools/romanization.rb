# encoding: utf-8
require 'zhongwen_tools/string'
require 'zhongwen_tools/romanization/conversion_table'
require 'zhongwen_tools/romanization/string'
require 'zhongwen_tools/romanization/pyn_to_py'

# TODO: follow tone conventions for different systems.
#       IPA	mä˥˥	mä˧˥	mä˨˩˦	mä˥˩	mä
#       Pinyin	mā	má	mǎ	mà	ma
#       Tongyong Pinyin	ma	má	mǎ	mà	må # this will be difficult.
#       Wade–Giles	ma¹	ma²	ma³	ma⁴	ma⁰
#       Zhuyin	ㄇㄚ	ㄇㄚˊ	ㄇㄚˇ	ㄇㄚˋ	•ㄇㄚ
module ZhongwenTools
  module Romanization
    extend self

    %w(pinyin py pyn bopomofo bpmf zhuyin zyfh zhyfh zhuyin_fuhao yale wade_giles wg typy tongyong mps2).each do |type|
      define_method("to_#{type}") do |*args|
        str, from = _romanization_options(args)
        _convert_romanization str, _set_type(type.to_sym), _set_type(from)
      end
    end

    private

    # Private: Provides romanization options for romanization methods. If no :from argument is given, then
    #          the method will try to guess the romanization. This can sometimes provide sub-optimal
    #          romanization suggestions. See lib/zhongwen_tools/romanization/detect.rb#romanization? for details.
    #
    # args - an Array of arguments. If the Object is a String, then the first argument should be the :from option.
    #        Otherwise, the first argument is a String and the second argument is the :from option.
    #
    # Examples:
    #
    #
    #   _romanization_options('hao3', :pyn) #=> 'hao3' :pyn
    #   _romanization_options('hao3') #=> 'hao3', :pyn
    #
    # Returns an Array. The first item is a String to be converted. The second item is a Symbol for the :from option.
    def _romanization_options(args)
      if self.class.to_s != 'String'
        str = args[0]
        from = args[1] || str.romanization? || :pyn
      else
        str = self
        from = args[0] || str.romanization? || :pyn
      end

      [str, from.to_sym]
    end

    #  Private: Replaces numbered pinyin with actual pinyin. Pinyin separated with hyphens are combined as one word.
    #
    #  str - A String to replace with actual pinyin
    #
    #  Examples
    #    _to_pinyin 'Ni3 hao3 ma5?'
    #    # => "Nǐ hǎo ma?"
    #    # => 'Zhong1-guo2-ren2'
    #
    #
    #  Returns a string with actual pinyin
    def _to_pinyin str
      # TODO: move regex to ZhongwenTools::Regex
      regex = /(([BPMFDTNLGKHZCSRJQXWYbpmfdtnlgkhzcsrjqxwy]?[h]?)(A[io]?|a[io]?|i[aeu]?o?|Ei?|ei?|Ou?|ou?|u[aoe]?i?|ve?)?(n?g?)(r?)([1-5])(\-+)?)/

      # Using gsub is ~8x faster than using scan and each.
      # Explanation: if it's pinyin without vowels, e.g. m, ng, then convert,
      #              otherwise, check if it needs an apostrophe (http://www.pinyin.info/romanization/hanyu/apostrophes.html).
      #              If it does, add it and then convert. Otherwise, just convert.
      #              Oh, and if double hyphens are used, replace them with one hyphen.
      #              And finally, correct those apostrophes at the very end.
      str.gsub(regex) do
        ($3.nil? ? "#{PYN_PY[$1]}" : ($2 == '' && ['a','e','o'].include?($3[0,1]))? "'#{PYN_PY["#{$3}#{$6}"]}#{$4}#{$5}" : "#{$2}#{PYN_PY["#{$3}#{$6}"]}#{$4}#{$5}") + (($7.to_s.length > 1) ? '-' : '')
      end.gsub("-'","-").sub(/^'/,'')
    end

    # http://en.wikipedia.org/wiki/Pinyin
    # http://talkbank.org/pinyin/Trad_chart_IPA.php
    # for ipa
    def _to_romanization str, to, from
      convert_to = _set_type to
      convert_from = _set_type from

      begin
        tokens = self.send("split_#{from}").uniq
      rescue
        tokens = str.split(/[ \-]/).uniq
      end

      tokens.collect do |t|
        search = t.gsub(/[1-5].*/,'')

        if from.nil?
          replace = (_replacement(t) || {}).fetch(to){search}
        else
          replace = (_replacement(t, from) || {}).fetch(to){search}
        end

        replace = _fix_capitalization(str, t, replace)
        str =  str.gsub(search, replace)
      end

      str
    end

    def _fix_capitalization(str, token, replace)
      replace = replace.capitalize  if(token.downcase != token)

      replace
    end

    def _replacement(token, from = nil)
      token = token.downcase.gsub(/[1-5].*/,'')
      ROMANIZATIONS_TABLE.find do |x|
        if from.nil?
          x.values.include?(token)
        else
          x[from] == token
        end
      end
    end

    def _convert_romanization str, to, from
      return str if to == from

      result =
        if to == :py
          str = _to_romanization str, :pyn, from if from != :pyn
          _to_pinyin str
        elsif to == :pyn
          if from == :py
            _convert_pinyin_to_pyn(str)
          else
            _to_romanization str, :pyn, from
          end
        else
          _to_romanization str, to, from
        end

      # TODO: check to see if wade giles, yale etc. can have hyphens.
      result = result.gsub('-','') if to == :zyfh
      result
    end

    def _convert_pinyin_to_pyn(pinyin)
      # TODO: should method check to make sure pinyin is accurate?
      pyn = []
      words =  pinyin.split(' ')

      pyn = words.map do |word|
        pys = word.split(/['\-]/).flatten.map{|x| x.scan(Regex.py).map{|x| (x - [nil])[0]}}.flatten
        _current_pyn(word, pys)
      end

      pyn.join(' ')
    end

    def _current_pyn(pyn, pinyin_arr)
      replacements = []
      pinyin_arr.each do |pinyin|
        replace =  pinyin_replacement(pinyin)
        match = pinyin
        pyn = pyn.sub(/(#{replacements.join('.*')}.*)#{match}/){ $1 + replace}
        replacements << replace
      end

      pyn.gsub("'",'')
    end

    def pinyin_replacement(py)
      matches = PYN_PY.values.select do |x|
        py.include? x
      end

      # take the longest pinyin match. Use bytes because 'è' is prefered over 'n' or 'r' or 'm'
      match = matches.sort{|x,y| x.bytes.length <=> y.bytes.length}[-1]

      # Edge case.. en/eng pyn -> py conversion is one way only.
      match = match[/^(ē|é|ě|è|e)n?g?/].nil? ? match : match.chars[0]

      replace = PYN_PY.find{|k,v| k if v == match}[0]

      py.gsub(match, replace).gsub(/([^\d ]*)(\d)([^\d ]*)/){$1 + $3 + $2}
    end


    def _set_type(type)
      type = type.to_s.downcase.to_sym
      return type if [:zyfh, :wg, :typy, :py, :mps2, :yale, :pyn].include? type

      if [:zhuyinfuhao, :zhuyin, :zhuyin_fuhao, :bopomofo, :bpmf, :zhyfh].include? type
        :zyfh
      elsif [:wade_giles, 'wade-giles'.to_sym].include? type
        :wg
      elsif [:tongyong, :typy, :ty].include? type
        :typy
      elsif type == :pinyin
        :py
      end
    end
  end
end

require 'zhongwen_tools/romanization/detect'
