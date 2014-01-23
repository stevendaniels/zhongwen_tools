module ZhongwenTools
  module Romanization

    pyn_regexes = {
      :bpm_regex => /(miu|[pm]ou|[bpm](o|e(i|ng?)?|a(ng?|i|o)?|i(e|ng?|a[no])?|u))/,
      :f_regex => /(f(ou?|[ae](ng?|i)?|u))/,
      :dt_regex => /(d(e(i|ng?)|i(a[on]?|u))|[dt](a(i|ng?|o)?|e(i|ng)?|i(a[on]?|e|ng|u)?|o(ng?|u)|u(o|i|an?|n)?))/,
      :nl_regex => /(neng?|[ln](a(i|ng?|o)?|e(i|ng)?|i(ang|a[on]?|e|ng?|u)?|o(ng?|u)|u(o|i|an?|n)?|ve?))/,
      :gkh_regex => /([ghk](a(i|ng?|o)?|e(i|ng?)?|o(u|ng)|u(a(i|ng?)?|i|n|o)?))/,
      :zczhch_regex => /(z[h]?ei|[cz]hua(i|ng?)?|[cz][h]?(a(i|ng?|o)?|en?g?|o(u|ng)?|u(a?n|o|i)?))/,
      :ssh_regex => /(song|shua(i|ng?)?|shei|s[h]?(a(i|ng?|o)?|en?g?|ou|u(a?n|o|i)?))/, 
      :r_regex => /(r([ae]ng?|i|e|ao|ou|ong|u[oin]|ua?n?))/,
      :jqx_regex => /([jqx](i(a(o|ng?)?|[eu]|ong|ng?)?|u(e|a?n)?))/,
      :aw_regex => /(wu|w?(a(i|o|ng?)?|ou?|e(i|ng?)?))/,
      :y_regex => /y(a(o|ng?)?|e|in?g?|o(u|ng)?|u(e|a?n)?)/
    }

    PINYIN_REGEX = /(#{pyn_regexes.values.join('|')})([1-5])?([\s\-]+)?/
    #bpm_regex}|#{f_regex}|#{dt_regex}|#{nl_regex}|#{gkh_regex}|#{zczhch_regex}|#{ssh_regex}|#{r_regex}|#{jqx_regex}|#{aw_regex}|#{y_regex})([1-5])?([\s\-]+)?/

    # Public: checks if a string is pinyin.
    #
    # Examples
    #   pyn?('pin1-yin1')
    #   # => true
    #
    # Returns Boolean.
    def pyn?(str = nil)
      str ||= self

      str.gsub(PINYIN_REGEX,'') == ''
    end

    # Public: checks if a string is wade-giles.
    #
    # Examples
    #   wg?('pin1-yin1')
    #   # => false
    # There are some situations where wg == pyn, but there's no way to differentiate the two.
    def wg?(str = nil)
      #it shouldn't be pyn, but it should be able to conver to pyn
      str ||= self
      #easy ones.. is it py? pyn? zyfh? gyrm?
      #harder ones: is it typy, msp2, yale, wg
      wg = str._convert_romanization(str, :wg, :pyn) 

      wg != pyn && wg.gsub(/[1-5]/,'')
    end
  end
end
