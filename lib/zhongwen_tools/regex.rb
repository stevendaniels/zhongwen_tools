# encoding: utf-8
module ZhongwenTools
  module Regex
    def self.pyn
      @pyn ||= /(#{pyn_regexes.values.join('|')}|r)([1-5])([\s\-]+)?/
    end

    def self.py
      # ([ĀÁǍÀA][io]?|[io]?|[][āáǎàaēéěèeūúǔùu]?o?|[ĒÉĚÈE]i?|[]i?|[ŌÓǑÒO]u?|[]u?|u[āáǎàaēoēéěèe]?i?|[]e?)(n?g?r?)){1,}
      @py ||= /(#{pyn_regexes.map { |_k, v| v.to_s[7..-2].gsub(/[aeiouv]/, py_tones) }.join('|')}([\s\-])?)/
    end

    def self.pinyin_num
      # FIXME: n?g? might need to be replaced with (ng|n)?
      /(([BPMFDTNLGKHZCSRJQXWYbpmfdtnlgkhzcsrjqxwy]?[h]?)(A[io]?|a[io]?|i[aeu]?o?|Ei?|ei?|Ou?|ou?|u[aoe]?i?|ve?)?(n?g?)(r?)([1-5])(\-+)?)/
    end

    def self.pinyin_toneless
      @pynt ||= /(#{pyn_regexes.values.join('|')}|r)([\s\-]+)?/
    end

    def self.fullwidth
      /[０-９Ａ-Ｚａ-ｚ％．：＃＄＆＋－／＼＝；＜＞]/
    end

    def self.capital_letters
      @capital_letters ||=  /(#{Regexp.union(ZhongwenTools::Caps::CAPS.keys)})/
    end

    def self.lowercase_letters
      @lowercase_letters ||= /(#{Regexp.union(ZhongwenTools::Caps::CAPS.values)})/
    end

    def self.zh
      /\p{Han}/
    end

    def self.punc
      /\p{Punct}/
    end

    def self.zh_punc
      # TODO: includes non-zh punctuation codes. Should only include punctuation in CJK ranges.
      @zh_punc ||= /[\u2E00-\u2E2E]|[\u2E30-\u2E3B]|[\u3001-\u3003]|[\u3008-\u3011]|[\u3014-\u301F]|[\u3030\u303D\u30A0\u30FB\uA4FE\uA4FF]|[\uA60D-\uA60F]|[\uA673\uA67E]|[\uA6F2-\uA6F7]|[\uA874-\uA877]|[\uA8CE\uA8CF]|[\uA8F8-\uA8FA]|[\uA92E\uA92F\uA95F]|[\uA9C1-\uA9CD]|[\uA9DE\uA9DF]|[\uAA5C-\uAA5F]|[\uAADE\uAADF\uAAF0\uAAF1\uABEB\uFD3E\uFD3F]|[\uFE10-\uFE19]|[\uFE30-\uFE52]|[\uFE54-\uFE61]|[\uFE63\uFE68\uFE6A\uFE6B]|[\uFF01-\uFF03]|[\uFF05-\uFF0A]|[\uFF0C-\uFF0F]|[\uFF1A\uFF1B\uFF1F\uFF20]|[\uFF3B-\uFF3D]|[\uFF3F\uFF5B\uFF5D]|[\uFF5F-\uFF65]/
    end

    def self.zh_numbers
      # TODO: include numbers like yotta, etc.
      # 垓	秭	穰	溝	澗	正	載 --> beyond 100,000,000!
      # Regional: Dong Guai
      /[〇零一壹幺二贰貳两兩三弎叁參仨四肆䦉五伍六陆陸七柒八捌九玖十拾廿卅百佰千仟万萬亿億]/
    end

    def self.zhs_numbers
      # TODO: check if 佰,仟 are the financial numbers in zhs
      /[〇零一壹幺二贰两三弎叁仨四肆䦉五伍六陆七柒八捌九玖十拾廿卅百佰千仟万亿]/
    end

    def self.zht_numbers
      /[〇零一壹幺二貳兩三弎參仨四肆䦉五伍六陸七柒八捌九玖十拾廿卅佰千仟萬億]/
    end

    def self.zh_number_multiple
      /[拾十百佰千仟万萬亿億]/
    end

    # Public: A Regex for bopomofo, a.k.a. Zhuyin Fuhao 注音符号.
    #
    # Examples
    #
    #
    #   bopomofo #=> <Regex>
    #
    # Returns a Regex.
    def self.bopomofo
      /\p{Bopomofo}/
    end

    private

    def self.pyn_regexes
      # http://stackoverflow.com/questions/20736291/regex-for-matching-pinyin
      # https://www.debuggex.com/r/_9kbxA6f00gIGiVo
      # NOTE: you might need to change the order of these regexes for more accurate matching of some pinyin.
      {
        nl_regex: /([nN]eng?|[lnLN](a(i|ng?|o)?|e(i|ng)?|i(ang|a[on]?|e|ng?|u)?|o(ng?|u)|u(o|i|an?|n)?|ve?))/,
        bpm_regex: /([mM]iu|[pmPM]ou|[bpmBPM](o|e(i|ng?)?|a(ng?|i|o)?|i(e|ng?|a[no])?|u))/,
        y_regex: /[yY](a(o|ng?)?|e|i(ng|n)?|o(u|ng)?|u(e|a?n)?)/,
        f_regex: /([fF](ou?|[ae](ng?|i)?|u))/,
        dt_regex: /([dD](e(i|ng?)|i(a[on]?|u))|[dtDT](a(i|ng?|o)?|e(i|ng)?|i(a[on]?|e|ng|u)?|o(ng?|u)|u(o|i|an?|n)?))/,
        gkh_regex: /([ghkGHK](a(i|ng?|o)?|e(i|ng?)?|o(u|ng)|u(a(i|ng?)?|i|n|o)?))/,
        zczhch_regex: /([zZ]h?ei|[czCZ]h?(e(ng?)?|o(ng?|u)?|ao|u?a(i|ng?)?|u?(o|i|n)?))/,
        ssh_regex: /([sS]ong|[sS]hua(i|ng?)?|[sS]hei|[sS][h]?(a(i|ng?|o)?|e(ng|n)?|ou|u(a?n|o|i)?|i))/,
        r_regex: /([rR]([ae]ng?|i|e|ao|ou|ong|u[oin]|ua?n?))/,
        jqx_regex: /([jqxJQX](i(a(o|ng?)?|[eu]|ong|ng?)?|u(e|a?n)?))/,
        aeo_regex: /(([aA](i|o|ng?)?|[oO]u?|[eE](i|ng?|r)?))/,
        w_regex: /([wW](a(i|ng?)?|o|e(i|ng?)?|u))/
      }
    end

    def self.py_syllabic_nasals
      # NOTE: includes combining diatrical marks for n̄ňm̄m̌m̀
      /((N̄|n̄|ň)g?|[ŇŃǸńǹ]g?|m̄|m̌|m̀|ḿ)/
    end

    def self.py_tones
      {
        'a' => '[āáǎàa]',
        'e' => '[ēéěèe]',
        'i' => '[īíǐìi]',
        'o' => '[ōóǒòo]',
        'u' => '[ūúǔùu]',
        'v' => '[ǖǘǚǜü]'
      }
    end

    def self.only_tones
      # NOTE: includes combining diatrical marks for n̄ňm̄m̌m̀
      /([āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜńǹḿŃŇǸ]|N̄|n̄|ň|m̄|m̌|m̀)/
    end
  end
end
