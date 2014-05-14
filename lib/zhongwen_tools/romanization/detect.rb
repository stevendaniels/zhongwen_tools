# encoding: utf-8
module ZhongwenTools
  module Romanization
    # https://www.debuggex.com/r/_9kbxA6f00gIGiVo

    #might need to change the order of these regexes?
    pyn_regexes = {
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

    if RUBY_VERSION < '1.9'
      py_tones = {
        'a' => '(ā|á|ǎ|à|a)',
        'e' => '(ē|é|ě|è|e)',
        'i' => '(ī|í|ǐ|ì|i)',
        'o' => '(ō|ó|ǒ|ò|o)',
        'u' => '(ū|ú|ǔ|ù|u)',
        'v' => '(ǖ|ǘ|ǚ|ǜ|ü)'
      }
      # might not need the space on the end.

      PY_REGEX = /(#{pyn_regexes.map{|k,v| v.to_s[7..-2].gsub_with_hash(/[aeiouv]/,py_tones)}.join('|')}(\s\-))/
    else
      py_tones = {
        'a' => '[āáǎàa]',
        'e' => '[ēéěèe]',
        'i' => '[īíǐìi]',
        'o' => '[ōóǒòo]',
        'u' => '[ūúǔùu]',
        'v' => '[ǖǘǚǜü]'
        #([ĀÁǍÀA][io]?|[io]?|[][āáǎàaēéěèeūúǔùu]?o?|[ĒÉĚÈE]i?|[]i?|[ŌÓǑÒO]u?|[]u?|u[āáǎàaēoēéěèe]?i?|[]e?)(n?g?r?)){1,}
      }
      PY_REGEX = /(#{pyn_regexes.map{|k,v| v.to_s[7..-2].gsub(/[aeiouv]/,py_tones)}.join('|')}(\s\-))/
    end

    PINYIN_REGEX = /(#{pyn_regexes.values.join('|')})([1-5])?([\s\-]+)?/

    # Public: checks if a string is pinyin.
    #
    # Examples
    #   py?('nǐ hǎo')
    #   # => true
    #
    # Returns Boolean.
    def py?(str = nil)
      str ||= self

      str.gsub(PY_REGEX, '').strip == ''
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

      str.gsub(PINYIN_REGEX,'').strip == ''
    end

    # Public: checks if a string is wade-giles.
    #
    # Examples
    #   wg?('pin1-yin1')
    #   # => false
    # There are some situations where wg == pyn, but there's no way to differentiate the two.
    def wg?(str = nil, type = :pyn)
      #it shouldn't be pyn, but it should be able to conver to pyn
      str ||= self
      #easy ones.. is it py? pyn? zyfh? gyrm?
      #harder ones: is it typy, msp2, yale, wg
      wg = ZhongwenTools::Romanization.to_wade_giles(str, type)
      # TODO: need to convert string to pyn.
      pyn = str
      wg != pyn && wg.gsub(/[1-5]/,'')
    end
  end
end
