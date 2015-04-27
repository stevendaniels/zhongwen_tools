# encoding: utf-8
require 'zhongwen_tools/regex'
require 'zhongwen_tools/caps'
require 'zhongwen_tools/romanization'

module ZhongwenTools
  # Public: Romanization converts to pinyin and pyn.
  module Romanization
    def self.convert_to_py(str, from)
      str =  convert_romanization(str, from, :pyn) if from != :pyn
      Pinyin.convert_pyn_to_pinyin(str)
    end

    def self.convert_to_pyn(str, from)
      orig_str = str.dup

      if from == :py
        str = Romanization::Pinyin.convert_pinyin_to_pyn(str)
      else
        str = convert_romanization(str, from, :pyn)
      end

      str = Romanization::Pinyin.add_hyphens_to_pyn(str) if hyphenated?(orig_str)

      str
    end

    # Public: methods to convert, detect and split pinyin or
    #         pyn (pinyin with numbers, e.g. hao3).
    module Pinyin
      %w(pinyin py pyn).each do |romanization|
        define_singleton_method("to_#{romanization}") do |*args|
          str, from = args
          from ||= Romanization.romanization? str

          Romanization.convert str, py_type(romanization), (py_type(from) || from)
        end
      end

      def self.split_pyn(str)
        # FIXME: ignore punctuation
        regex = str[/[1-5]/].nil? ? /(#{ Regex.pinyin_toneless })/ : /(#{ Regex.pyn }|#{ Regex.pinyin_toneless })/
        # NOTE: p[/[^\-]*/].to_s is 25% faster than gsub('-', '')
        str.scan(regex).map { |arr| arr[0].strip[/[^\-]*/].to_s }.flatten
      end

      def self.split_py(str)
        words = str.split(' ')

        results = words.map do |word|
          word, is_capitalized = normalize_pinyin(word)
          word = normalize_n_g(word)
          word = normalize_n(word)
          result = word.split(/['\-]/).flatten.map do |x|
            find_py(x)
          end

          # NOTE: Special Case split_py('wányìr')   # => ['wán', 'yì', 'r']
          result << 'r' unless word[/(.*[^#{ Regex.py_tones['e'] }.])(r)$/].nil?

          recapitalize(result.flatten, is_capitalized)
        end

        results.flatten
      end

      # Public: checks if a string is pinyin.
      #         http://en.wikipedia.org/wiki/Pinyin
      #
      # Examples
      #   py?('nǐ hǎo')
      #   # => true
      #
      # Returns Boolean.
      def self.py?(str)
        if str[Regex.only_tones].nil? && str[/[1-5]/].nil?
          pyn?(str)
        else
          # TODO: py regex does not include capitals with tones.
          # NOTE: Special Case "fǎnguāng" should be "fǎn" + "guāng"

          regex = /(#{ Regex.punc }|#{ Regex.py }|#{ Regex.py_syllabic_nasals }|[\s\-])/
          str = str.gsub('ngu', 'n-gu')
          Caps.downcase(str).gsub(regex, '').strip == ''
        end
      end

      # Public: checks if a string is pinyin.
      #
      # Examples
      #   pyn?('pin1-yin1')
      #   # => true
      #
      # Returns Boolean.
      def self.pyn?(str)
        # FIXME: use strip_punctuation method
        normalized_str = Caps.downcase(str.gsub(Regex.punc, '').gsub(/[\s\-]/, ''))
        pyn_arr = split_pyn(normalized_str).map{ |p| p }
        pyn_arr << normalized_str if pyn_arr.size == 0 && PYN_SYLLABIC_NASALS.include?(normalized_str.gsub(/[1-5]/, ''))

        pyn_matches_properly?(pyn_arr, normalized_str) &&
          are_all_pyn_syllables_complete?(pyn_arr)
      end

      def self.add_hyphens_to_pyn(str)
        results = str.split(' ').map do |s|
          split_pyn(s).join('-')
        end

        results.join(' ')
      end

      private

      def self.pyn_matches_properly?(pyn_arr, normalized_str)
        pyn_arr.join('') == normalized_str
      end

      def self.are_all_pyn_syllables_complete?(pyn_arr)
        pyns = ROMANIZATIONS_TABLE.map{ |r| r[:pyn] } + PYN_SYLLABIC_NASALS

        pyn_syllables = pyn_arr.select do |p|
          pyns.include?(p.gsub(/[1-5]/, ''))
        end

        pyn_arr.size == pyn_syllables.size
      end

      def self.py_type(romanization)
        romanization = romanization.to_s.downcase.to_sym

        { pyn: :pyn, py: :py, pinyin: :py }[romanization]
      end

      # NOTE: Special Case split_py("fǎnguāng") # => ["fǎn" + "guāng"]
      #       In pinyin, sāngēng == sān gēng and sāng'ēng = sāng ēng
      def self.normalize_n_g(pinyin)
        regex = /(?<n_part>n)(?<g_part>g(#{Regex.py_tones['o']}|#{Regex.py_tones['u']}|#{Regex.py_tones['a']}|#{Regex.py_tones['e']}))/
        pinyin.gsub(regex) do
          "#{Regexp.last_match[:n_part]}-#{Regexp.last_match[:g_part]}"
        end
      end

      def self.normalize_n(pinyin)
        #       Special Case split_py("yìnián")   # => ["yì" + "nián"]
        #                    split_py("Xīní")     # => ["Xī", "ní"]
        regex = /([#{ Regex.only_tones }])(n(#{Regex.py_tones['v']}|#{Regex.py_tones['i']}|[iu]|#{Regex.py_tones['e']}|[#{Regex.py_tones['a']}]))/
        pinyin.gsub(regex) { "#{ $1 }-#{ $2 }" }
      end

      def self.normalize_pinyin(pinyin)
        [Caps.downcase(pinyin), capitalized?(pinyin)]
      end

      def self.find_py(str)
        regex = /(#{ Regex.py }|#{ Regex.py_syllabic_nasals })/
        str.scan(regex).map { |x| x.compact[0] }
      end

      def self.recapitalize(obj, capitalized)
        return obj unless capitalized

        if obj.is_a? String
          Caps.capitalize(obj)
        elsif obj.is_a? Array
          [Caps.capitalize(obj[0]), obj[1..-1]].flatten
        end
      end

      # Internal: converts real pinyin to pinyin number string.
      #
      # pinyin - A String for the pinyin.
      #
      # Examples
      #
      #   convert_pinyin_to_pyn('Nǐ hǎo ma') #=> 'Ni3 hao3 ma5?'
      #
      # Returns a String in pinyin number format.
      def self.convert_pinyin_to_pyn(pinyin)
        words = pinyin.split(' ')

        pyn = words.map do |word|
          # NOTE: if a word is upcase, then it will be converted the same
          #       as a word that is only capitalized.
          word, is_capitalized = normalize_pinyin(word)
          pys = split_py(word)

          recapitalize(current_pyn(word, pys), is_capitalized)
        end

        pyn.join(' ')
      end

      def self.capitalized?(str)
        first_letter = str[/#{Regex.py}|[ĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒ]|#{Regex.py_syllabic_nasals}/][0]

        first_letter != Caps.downcase(first_letter)
      end

      def self.current_pyn(pyn, pinyin_arr)
        pinyin_arr.each do |pinyin|
          replace =  pinyin_replacement(pinyin)
          pyn.sub!(pinyin, replace)
        end

        pyn.gsub("'", '')
      end

      def self.pinyin_replacement(py)
        matches = PYN_PY.values.select do |x|
          py.include? x
        end

        match = select_pinyin_match(matches)
        replace = PYN_PY.find { |k, v| k if v == match }[0]

        py.gsub(match, replace).gsub(/([^\d ]*)(\d)([^\d ]*)/){ $1 + $3 + $2 }
      end

      def self.select_pinyin_match(matches)
        # take the longest pinyin match. Use bytes because 'è' is prefered over 'n' or 'r' or 'm'
        match = matches.sort { |x, y| x.bytes.to_a.length <=> y.bytes.to_a.length }[-1]

        # Edge case.. en/eng pyn -> py conversion is one way only.
        match[/^(ē|é|ě|è|e)n?g?/].nil? ? match : match.chars[0]
      end

      #  Internal: Replaces numbered pinyin with actual pinyin. Pinyin separated with hyphens are combined as one word.
      #
      #  str - A String to replace with actual pinyin
      #
      #  Examples
      #
      #    convert_pyn_to_pinyin 'Ni3 hao3 ma5?' # => "Nǐ hǎo ma?"
      #
      #
      #  Returns a string with actual pinyin
      def self.convert_pyn_to_pinyin(str)
        regex = Regex.pinyin_num
        # NOTE: Using gsub is ~8x faster than using scan and each.
        # NOTE: if it's pinyin without vowels, e.g. m, ng, then convert,
        #       otherwise, check if it needs an apostrophe (http://www.pinyin.info/romanization/hanyu/apostrophes.html).
        #       If it does, add it and then convert. Otherwise, just convert it.
        #       Oh, and if it has double hyphens, replace with one hyphen.
        #       And finally, correct those apostrophes at the very end.
        #       It's like magic.
        str.gsub(regex) do
          ($3.nil? ? "#{ PYN_PY[$1] }" : ($2 == '' && %w(a e o).include?($3[0,1]))? "'#{ PYN_PY["#{ $3 }#{ $6 }"]}#{ $4 }#{ $5 }" : "#{ $2 }#{ PYN_PY["#{ $3 }#{ $6 }"] }#{ $4 }#{ $5 }") + (($7.to_s.length > 1) ? '-' : '')
        end.gsub("-'", '-').sub(/^'/, '')
      end
    end
  end
end
