# encoding: utf-8
module ZhongwenTools
  module Regex
    extend self

    def pyn
      /(#{pyn_regexes.values.join('|')}|r)([1-5])?([\s\-]+)?/
    end

    def py
      # FIXME: need to detect Ālābó
      # ([ĀÁǍÀA][io]?|[io]?|[][āáǎàaēéěèeūúǔùu]?o?|[ĒÉĚÈE]i?|[]i?|[ŌÓǑÒO]u?|[]u?|u[āáǎàaēoēéěèe]?i?|[]e?)(n?g?r?)){1,}
      /(#{pyn_regexes.map{|k,v| v.to_s[7..-2].gsub_with_hash(/[aeiouv]/,py_tones)}.join('|')}([\s\-])?)/
    end

    def fullwidth
      /[０-９Ａ-Ｚａ-ｚ％．：＃＄＆＋－／＼＝；＜＞]/
    end

    def capital_letters
      /(#{Regexp.union(ZhongwenTools::UNICODE_CAPS.keys)})/
    end

    def lowercase_letters
      /(#{Regexp.union(ZhongwenTools::UNICODE_CAPS.values)})/
    end

    def zh
      /[\u2E80-\u2E99]|[\u2E9B-\u2EF3]|[\u2F00-\u2FD5]|[\u3005|\u3007]|[\u3021-\u3029]|[\u3038-\u303B]|[\u3400-\u4DB5]|[\u4E00-\u9FCC]|[\uF900-\uFA6D]|[\uFA70-\uFAD9]/
    end

    def punc
      /[\u0021-\u0023]|[\u0025-\u002A]|[\u002C-\u002F]|[\u003A\u003B\u003F\u0040]|[\u005B-\u005D\u005F\u007B\u007D\u00A1\u00A7\u00AB\u00B6\u00B7\u00BB\u00BF\u037E\u0387]/
    end

    def zh_punc
      # TODO: includes non-zh punctuation codes. Should only include punctuation in CJK ranges.
      /[\u2E00-\u2E2E]|[\u2E30-\u2E3B]|[\u3001-\u3003]|[\u3008-\u3011]|[\u3014-\u301F]|[\u3030\u303D\u30A0\u30FB\uA4FE\uA4FF]|[\uA60D-\uA60F]|[\uA673\uA67E]|[\uA6F2-\uA6F7]|[\uA874-\uA877]|[\uA8CE\uA8CF]|[\uA8F8-\uA8FA]|[\uA92E\uA92F\uA95F]|[\uA9C1-\uA9CD]|[\uA9DE\uA9DF]|[\uAA5C-\uAA5F]|[\uAADE\uAADF\uAAF0\uAAF1\uABEB\uFD3E\uFD3F]|[\uFE10-\uFE19]|[\uFE30-\uFE52]|[\uFE54-\uFE61]|[\uFE63\uFE68\uFE6A\uFE6B]|[\uFF01-\uFF03]|[\uFF05-\uFF0A]|[\uFF0C-\uFF0F]|[\uFF1A\uFF1B\uFF1F\uFF20]|[\uFF3B-\uFF3D]|[\uFF3F\uFF5B\uFF5D]|[\uFF5F-\uFF65]/
    end

    def zh_numbers
      # TODO: include numbers like yotta, etc.
      # 垓	秭	穰	溝	澗	正	載 --> beyond 100,000,000!
      /[〇零一壹幺二贰貳两兩三弎叁參四肆䦉五伍六陆陸七柒八捌九玖十拾廿百佰千仟万萬亿億]/
    end

    # Public: A Regex for bopomofo, a.k.a. Zhuyin Fuhao 注音符号.
    #
    # Examples
    #
    #
    #   bopomofo #=> <Regex>
    #
    # Returns a Regex.
    def bopomofo
      /[ㄅㄆㄇㄈㄉㄊㄋㄌㄍㄎㄏㄐㄑㄒㄓㄔㄕㄖㄗㄘㄙㄚㄛㄜㄝㄞㄟㄠㄡㄢㄣㄤㄥㄦㄧㄨㄩ]/
    end

    private
    def pyn_regexes
      # http://stackoverflow.com/questions/20736291/regex-for-matching-pinyin
      # https://www.debuggex.com/r/_9kbxA6f00gIGiVo
      # NOTE: you might need to change the order of these regexes for more accurate matching of some pinyin.
      {
        :nl_regex => /([nN]eng?|[lnLN](a(i|ng?|o)?|e(i|ng)?|i(ang|a[on]?|e|ng?|u)?|o(ng?|u)|u(o|i|an?|n)?|ve?))/,
        :bpm_regex => /([mM]iu|[pmPM]ou|[bpmBPM](o|e(i|ng?)?|a(ng?|i|o)?|i(e|ng?|a[no])?|u))/,
        :f_regex => /([fF](ou?|[ae](ng?|i)?|u))/,
        :dt_regex => /([dD](e(i|ng?)|i(a[on]?|u))|[dtDT](a(i|ng?|o)?|e(i|ng)?|i(a[on]?|e|ng|u)?|o(ng?|u)|u(o|i|an?|n)?))/,
        :gkh_regex => /([ghkGHK](a(i|ng?|o)?|e(i|ng?)?|o(u|ng)|u(a(i|ng?)?|i|n|o)?))/,
        :zczhch_regex => /([zZ]h?ei|[czCZ]h?(e(ng?)?|o(ng?|u)?|ao|u?a(i|ng?)?|u?(o|i|n)?))/,
        :ssh_regex => /([sS]ong|[sS]hua(i|ng?)?|[sS]hei|[sS][h]?(a(i|ng?|o)?|en?g?|ou|u(a?n|o|i)?|i))/,
        :r_regex => /([rR]([ae]ng?|i|e|ao|ou|ong|u[oin]|ua?n?))/,
        :jqx_regex => /([jqxJQX](i(a(o|ng?)?|[eu]|ong|ng?)?|u(e|a?n)?))/,
        :aeo_regex => /(([aA](i|o|ng?)?|[oO]u?|[eE](i|ng?|r)?))/,
        :w_regex => /([wW](a(i|ng?)?|o|e(i|ng?)?|u))/,
        :y_regex => /[yY](a(o|ng?)?|e|in?g?|o(u|ng)?|u(e|a?n)?)/
      }
    end

    def py_tones
      py_tones = {
        'a' => '[āáǎàa]',
        'e' => '[ēéěèe]',
        'i' => '[īíǐìi]',
        'o' => '[ōóǒòo]',
        'u' => '[ūúǔùu]',
        'v' => '[ǖǘǚǜü]'
      }
    end
  end
end

require File.expand_path("../regex/ruby18", __FILE__) if RUBY_VERSION < '1.9'
