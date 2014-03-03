#encoding: utf-8
require File.expand_path("../romanization/conversion_table", __FILE__)
require File.expand_path("../romanization/detect", __FILE__)
require File.expand_path("../romanization/pyn_to_py", __FILE__)

module ZhongwenTools
  module Romanization
    def to_pinyin(*args)
      str, from = _romanization_options(args)

      _convert_romanization str, :py, from
    end

    def to_bopomofo *args
      str, from = _romanization_options(args)

      _convert_romanization str, :zyfh, from
    end

    def to_yale(*args)
      str, from = _romanization_options(args)
      _convert_romanization str, :yale, from
    end

    def to_wade_giles(*args)
      str, from = _romanization_options(args)
      _convert_romanization str, :wg, from
    end

    def to_typy(*args)
      str, from = _romanization_options(args)
      _convert_romanization str, :typy, from
    end

    private

    def _romanization_options(args)
      if self.class.to_s != 'String'
        str = args[0]
        from = (args[1] || :pyn).to_sym
      else
        str = self
        from = (args[0] || :pyn).to_sym
      end

      [str, from]
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
    #  TODO: fix regex: false match for V
    #  TODO: fix regex false match for "zhongguo person"
    #  #this regex is a quick and dirty check, but it's not accurate.
    #  an accurate regex would restrict access to completely accurate
    #  pinyin, e.g. sounds that mandarin actually can contain.
    #  #this regex extracts the pinyin components, but doesn't make
    #  judgement on the pinyins accuracy.
    def _to_pinyin str
      regex = /(([BPMFDTNLGKHZCSRJQXWYbpmfdtnlgkhzcsrjqxwy]?[h]?)(A[io]?|a[io]?|i[aeu]?o?|Ei?|ei?|Ou?|ou?|u[aoe]?i?|ve?)?(n?g?)(r?)([1-5])(\-+)?)/

      # doing the substitution in a block is ~8x faster than using scan and each.
      # Explanation: if it's pinyin without vowels, e.g. m, ng, then convert, otherwise, check if it needs an apostrophe (http://www.pinyin.info/romanization/hanyu/apostrophes.html). If it does, add it and then convert. Otherwise, just convert. Oh, and if double hyphens are used, replace them with one hyphen. And finally, correct those apostrophes at the very end.
      str.gsub(regex) do
        ($3.nil? ? "#{PYN_PY[$1]}" : ($2 == '' && ['a','e','o'].include?($3[0,1]))? "'#{PYN_PY["#{$3}#{$6}"]}#{$4}#{$5}" : "#{$2}#{PYN_PY["#{$3}#{$6}"]}#{$4}#{$5}") + (($7.to_s.length > 1) ? '-' : '')
      end.gsub("-'","-").sub(/^'/,'')
    end

    #http://en.wikipedia.org/wiki/Pinyin
    #http://talkbank.org/pinyin/Trad_chart_IPA.php
    #for ipa
    def _to_romanization str, to, from
      convert_to = _set_type to
      convert_from = _set_type from
      tokens = str.split(/[ \-]/).uniq
      replacements = tokens.collect do |t|
        # non_romanization = t.match(/[1-5](.*)/)[-1]
        search = t.gsub(/[1-5].*/,'')
        begin
          capitalized = t.downcase != t
          if from.nil? || convert_from.nil?
            replace = ROMANANIZATIONS_TABLE.find{|x| x.values.include? t.downcase.gsub(/[1-5].*/,'')}[convert_to.to_sym]
          else
            replace = ROMANANIZATIONS_TABLE.find{|x| x[convert_from.to_sym] == t.downcase.gsub(/[1-5].*/,'')}[convert_to.to_sym]
          end
        rescue =>  e#rescue when the converter meets something it doesn't recognize
          replace = search
        end

        replace = replace.capitalize if capitalized
        str =  str.gsub(search, replace)
      end
      str
    end
    def _convert_romanization str, to, from
      return str if to == from

      if to == :py
        if from == :pyn
          _to_pinyin str
        else
          raise NotImplementedError, 'method not implemented'
          #convert to pyn first.
        end
      elsif to == :zyfh
        if from == :py
          #need to convert pinyin to pyn
          raise NotImplementedError, 'method not implemented'
        end
        _to_romanization(str, to, from).gsub('-','')
      else
        if from == :pyn
          _to_romanization str, to, from
        else
          raise NotImplementedError, 'method not implemented'
        end
      end
    end


    def _set_type(type)
      type = type.to_s.downcase.to_sym
      case type
      when :zhuyinfuhao
        :zyfh
      when :bopomofo
        :zyfh
      when :bpmf
        type = :zyfh
      when :zhyfh
        type = :zyfh
      when :zyfh
        :zyfh
      when 'wade-giles'.to_sym
        type = :wg
      when :yale
        :yale
      when :tongyong
        type = :typy
      when :wg
        type = :wg
      when :typy
        :typy
      when :ty
        type = :typy
      when :pyn
        :py
      when :pinyin
        type = :py
      when :py
        type = :py
      when :msp2
        :msp2
      else
        nil
      end
    end

    alias_method :to_py, :to_pinyin
    alias_method :to_zhyfh, :to_bopomofo
    alias_method :to_zhuyin, :to_bopomofo
    alias_method :to_zhuyin_fuhao, :to_bopomofo
    alias_method :to_bpmf, :to_bopomofo
    alias_method :to_wg, :to_wade_giles
    alias_method :to_tongyong, :to_typy
  end
end
