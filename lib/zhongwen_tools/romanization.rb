# encoding: utf-8
require 'zhongwen_tools/romanization/pinyin'
require 'zhongwen_tools/romanization/pinyin_table'
require 'zhongwen_tools/romanization/zhuyin_fuhao'
require 'zhongwen_tools/romanization/tongyong_pinyin'
require 'zhongwen_tools/romanization/wade_giles'
require 'zhongwen_tools/romanization/yale'
require 'zhongwen_tools/romanization/mps2'
require 'zhongwen_tools/romanization/romanization_table'

# NOTE: Creates several dynamic Modules and their associated methods.
#       e.g. ZhongwenTools::Romanization::ZhuyinFuhao.to_bpmf
#            ZhongwenTools::Romanization::WadeGiles.to_wg
module ZhongwenTools
  module Romanization
    def self.convert(str, to, from)
      # NOTE: don't convert if it already is converted.
      return str if to == from

      if to == :py
        convert_to_py(str, from)
      elsif to == :pyn
        convert_to_pyn(str, from)
      else
        convert_to_other(str, from, to)
      end
    end

    # Public: Checks the romanization type for the string.
    #         Romanization types are like ducks. If it walks, talks, and acts
    #         like a duck, it is a duck. Therefore, where a String is both
    #         pinyin and another romanization system, it will be identified
    #         as pinyin. If you need to determine whether a py/pyn string
    #         belongs to another romanization system p a romanization
    #         system, use the romanization modules specific function.
    #
    #         Zhuyin Fuhao, Tongyong Pinyin, Wade Giles, MSP2 or Yale.
    #         http://en.wikipedia.org/wiki/Tongyong_Pinyin
    #         http://pinyin.info/romanization/tongyong/
    #         http://en.wikipedia.org/wiki/Wade%E2%80%93Giles
    #         http://en.wikipedia.org/wiki/Bopomofo
    #         http://pinyin.info/romanization/bopomofo/index.html  # str - a String to test.
    #
    # Examples
    #    romanization?('hao3') #=> :pyn
    #    romanization?('zzzz')   #=> nil
    #
    #
    # Returns a String for the romanization system or Nil if the string is not
    # a romanization.
    def self.romanization?(str)
      if ZhongwenTools::Romanization::Pinyin.pyn?(str)
        :pyn
      elsif ZhongwenTools::Romanization::Pinyin.py?(str)
        :py
      elsif ZhongwenTools::Romanization::ZhuyinFuhao.bpmf?(str)
        :bpmf
      elsif ZhongwenTools::Romanization::WadeGiles.wg?(str)
        :wg
      elsif ZhongwenTools::Romanization::TongyongPinyin.typy?(str)
        :typy
      elsif ZhongwenTools::Romanization::Yale.yale?(str)
        :yale
      elsif ZhongwenTools::Romanization::MPS2.mps2?(str)
        :mps2
      end
    end

    def self.split(str, type = nil)
      # should probably yield
      type ||= romanization?(str)

      if type == :py
      elsif type == :pyn
      end

    end

    private

    def self.detect_romanization(str, regex)
      normalized_str = str.downcase.gsub(ZhongwenTools::Regex.punc, '').gsub(/[1-5\s\-']/, '')
      #TODO: ignore tonal marks from other systems wade giles, tongyong etc.

      normalized_str.scan(regex).join == normalized_str
    end

    def self.split_romanization(str, regex)
      # TODO: ignore tonal marks from other systems wade giles, tongyong etc.
      results = str.scan(regex).map do |arr|
        arr[0].strip.gsub('-','')
      end

      results.flatten - ['']
    end

    def self.convert_romanization(str, from, to)
        # NOTE: extract/refactor tokens cause tests to fail.
        if from == :pyn
          tokens = ZhongwenTools::Romanization::Pinyin.split_pyn(str).uniq
        else
          tokens = romanization_module(from).send(:split, str).uniq
        end

     tokens.collect do |t|
        search, replace = find_token_replacement(t, str, to, from)
        str =  str.gsub(search, replace)
      end

      str
    end

    def self.convert_to_other(str, from, to)
      if from == :py
        str =  ZhongwenTools::Romanization::Pinyin.convert_pinyin_to_pyn(str)
        from = :pyn
      end

      str = convert_romanization(str, from, to)

      if to == :bpmf
        str.gsub('-', '')
      else
        str
      end
    end

    def self.find_token_replacement(token, str, to, from)
      search = token.gsub(/[1-5].*/,'')

      replace = token_replacement(token, from).fetch(to){ search }
      replace = fix_capitalization(str, token, replace)

      [search, replace]
    end

    def self.fix_capitalization(str, token, replace)
      replace = replace.capitalize  if(token.downcase != token)

      replace
    end

    def self.token_replacement(token, from = nil)
      token = token.downcase.gsub(/[1-5].*/,'')
      result = ROMANIZATIONS_TABLE.find do |x|
        if from.nil?
          x.values.include?(token)
        else
          x[from] == token
        end
      end

      result || {}
    end

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
    def self.detect_regex(type)
      /#{romanization_values(type).sort{|x,y| x.size <=> y.size}.reverse.join('|')}/
    end

    # Internal: Selects the romanization values for a particular romanization type.
    #
    # type - a Symbol for the romanization type.
    #
    # Examples:
    #
    #
    #   romanization_values(:typy) #=> ['a', ..., 'r']
    #
    # Returns an Array that contains the romanization's values.
    def self.romanization_values(type)
      results = ZhongwenTools::Romanization::ROMANIZATIONS_TABLE.map do |r|
        "[#{r[type][0]}#{r[type][0].upcase}]#{r[type][1..-1]}" || r[:pyn]
      end

      results.flatten
    end

    def self.romanization_module(type)
      module_name = RomanizationTypes.find{ |k,v| v.include?(type.to_s) }.first
      ZhongwenTools::Romanization.const_get(module_name)
    end

    def self.hyphenated?(str)
      !str[/\-/].nil?
    end

    # Internal: Creates romanization modules and their methods.
    RomanizationTypes = {
      ZhuyinFuhao: %w(bpmf zhuyin_fuhao zhuyinfuhao zyfh zhyfh bopomofo),
      WadeGiles: %w(wg wade_giles),
      Yale: ['yale'],
      TongyongPinyin: %w(typy tongyong tongyong_pinyin),
      MPS2: ['mps2']
    }
  end
end
