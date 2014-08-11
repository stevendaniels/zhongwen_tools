# encoding: utf-8
require 'zhongwen_tools/regex'
require 'zhongwen_tools/caps'
require 'zhongwen_tools/romanization'

module ZhongwenTools
  module Romanization

    def self.convert_to_py(str, from)
      str =  convert_romanization(str, from, :pyn) if from != :pyn
      ZhongwenTools::Romanization::Pinyin.convert_pyn_to_pinyin(str)
    end

    def self.convert_to_pyn(str, from)
      orig_str = str.dup

      if from == :py
        str = ZhongwenTools::Romanization::Pinyin.convert_pinyin_to_pyn(str)
      else
        str = convert_romanization(str, from, :pyn)
      end

      str = ZhongwenTools::Romanization::Pinyin.add_hyphens_to_pyn(str) if hyphenated?(orig_str)

      str
    end

    module Pinyin
      %w(pinyin py pyn).each do |romanization|
        define_singleton_method("to_#{romanization}") do |*args|
          str, from = args
          from ||= ZhongwenTools::Romanization.romanization? str

          #_convert_romanization str, _set_type(type.to_sym), _set_type(from)
          ZhongwenTools::Romanization.convert str, py_type(romanization), (py_type(from) || from)
        end
      end

      def self.split_pyn(str)
        # FIXME: ignore punctuation
        regex = str[/[1-5]/].nil? ?  /(#{ZhongwenTools::Regex.pinyin_toneless})/ : /(#{ZhongwenTools::Regex.pyn})/

        str.scan(regex).map{ |arr| arr[0].strip.gsub('-','') }.flatten
      end

      def self.split_py(str)
        words = str.split(' ')

        results = words.map do |word|
          word, is_capitalized = normalize_pinyin(word)
          result = word.split(/['\-]/).flatten.map do |x|
            find_py(x)
          end

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
        # NOTE: py regex does not include capitals with tones.
        #ZhongwenTools::Caps.downcase(str).gsub(ZhongwenTools::Regex.punc,'').gsub(Regex.py, '').gsub(/[\s\-]/,'').strip == ''
        regex = /(#{ ZhongwenTools::Regex.punc }|#{ ZhongwenTools::Regex.py }|[\s\-])/
          ZhongwenTools::Caps.downcase(str).gsub(regex, '').strip == ''
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
        normalized_str = ZhongwenTools::Caps.downcase(str.gsub(ZhongwenTools::Regex.punc,'').gsub(/[\s\-]/,''))
        pyn_arr = split_pyn(normalized_str).map{ |p| p }

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
        pyns = ROMANIZATIONS_TABLE.map{ |r| r[:pyn] }

        pyn_syllables = pyn_arr.select do |p|
          pyns.include?(p.gsub(/[1-5]/, ''))
        end

        pyn_arr.size == pyn_syllables.size
      end

      def self.py_type(romanization)
        romanization = romanization.to_s.downcase.to_sym

        { pyn: :pyn, py: :py, pinyin: :py }[romanization]
      end


      def self.normalize_pinyin(pinyin)
        [ZhongwenTools::Caps.downcase(pinyin), capitalized?(pinyin)]
      end

      def self.find_py(str)
        str.scan(ZhongwenTools::Regex.py).map{ |x| (x - [nil])[0] }

      end

      def self.recapitalize(obj, capitalized)
        return obj unless capitalized

        if obj.class == String
          ZhongwenTools::Caps.capitalize(obj)
        elsif obj.class == Array
          [ZhongwenTools::Caps.capitalize(obj[0]), obj[1..-1]].flatten
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
          #is_capitalized ? ZhongwenTools::Caps.capitalize(result) : result
          recapitalize(current_pyn(word, pys), is_capitalized)
        end

        pyn.join(' ')
      end

      def self.capitalized?(str)
        str[0] != ZhongwenTools::Caps.downcase(str[0])
      end

      def self.current_pyn(pyn, pinyin_arr)
        replacements = []
        pinyin_arr.each do |pinyin|
          replace =  pinyin_replacement(pinyin)
          match = pinyin
          if replacements.size > 0
            pyn = pyn.sub(/(#{replacements.join('.*')}.*)#{match}/){ $1 + replace }
          else
            pyn = pyn.sub(/#{match}/){ "#{$1}#{replace}"}
            end
          replacements << replace
        end

        pyn.gsub("'", '')
      end

      def self.pinyin_replacement(py)
        matches = PYN_PY.values.select do |x|
          py.include? x
        end
        match = select_pinyin_match(matches)
        replace = PYN_PY.find{|k,v| k if v == match}[0]

        py.gsub(match, replace).gsub(/([^\d ]*)(\d)([^\d ]*)/){$1 + $3 + $2}
      end

      def self.select_pinyin_match(matches)
        # take the longest pinyin match. Use bytes because 'è' is prefered over 'n' or 'r' or 'm'
        match = matches.sort{|x,y| x.bytes.to_a.length <=> y.bytes.to_a.length}[-1]

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
        # Using gsub is ~8x faster than using scan and each.
        # Explanation: if it's pinyin without vowels, e.g. m, ng, then convert,
        #              otherwise, check if it needs an apostrophe (http://www.pinyin.info/romanization/hanyu/apostrophes.html).
        #              If it does, add it and then convert. Otherwise, just convert.
        #              Oh, and if it has double hyphens, replace with one hyphen.
        #              And finally, correct those apostrophes at the very end.
        #              It's like magic.
        str.gsub(regex) do
          ($3.nil? ? "#{PYN_PY[$1]}" : ($2 == '' && ['a','e','o'].include?($3[0,1]))? "'#{PYN_PY["#{$3}#{$6}"]}#{$4}#{$5}" : "#{$2}#{PYN_PY["#{$3}#{$6}"]}#{$4}#{$5}") + (($7.to_s.length > 1) ? '-' : '')
        end.gsub("-'","-").sub(/^'/,'')
      end
    end
  end
end
