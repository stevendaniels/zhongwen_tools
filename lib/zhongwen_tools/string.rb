# encoding: utf-8
#$:.unshift File.join(File.dirname(__FILE__),'..','lib','zhongwen_tools', 'string')
require 'uri'
require 'zhongwen_tools/regex'
require 'zhongwen_tools/string/fullwidth'
require 'zhongwen_tools/string/caps'

class String
  alias_method :_downcase, :downcase
  alias_method :_upcase, :upcase
  alias_method :gsub_with_hash, :gsub

  def downcase
    self._downcase.gsub(/(#{ZhongwenTools::UNICODE_CAPS.keys.join('|')})/){
      ZhongwenTools::UNICODE_CAPS[$1]
    }
  end

  def upcase
    self._upcase.gsub(/(#{ZhongwenTools::UNICODE_CAPS.values.join('|')})/){
      ZhongwenTools::UNICODE_CAPS.find{|k,v| v == $1}[0]
    }
  end

  def capitalize
    #sub only substitues the first occurence.
    self.sub(self.chars[0], self.chars[0].upcase)
  end

  def scan_utf8(regex)
    scan(regex)
  end
end


module ZhongwenTools
  module String
    extend self

    # Deprecated: a Hash of unicode Regexes. Use ZhongwenTools::Regex.zh instead
    UNICODE_REGEX = {
      :zh => Regex.zh,
      :punc => Regex.zh_punc
    }

    def to_utf8(str = nil)
      (str || self).force_encoding('utf-8')
      #TODO: better conversion methods can be extracted from categories service
    end

    def has_zh?(str = nil)
      str ||= self

      !str[/(#{Regex.zh}|#{Regex.zh_punc})/].nil?
    end

    def zh?(str = nil)
      str ||= self

      str.scan(/(#{Regex.zh}+|#{Regex.zh_punc}+|\s+)/).join == str
    end

    def downcase(str = nil)
      str ||= self

      str.downcase
    end

    def upcase(str = nil)
      str ||= self

      str.upcase
    end

    def capitalize(str = nil)
      str ||= self

      str.capitalize
    end

    def has_zh_punctuation?(str = nil)
      str ||= self

      !str[Regex.zh_punc].nil?
    end

    def strip_zh_punctuation(str = nil)
      str ||= self

      str.gsub(Regex.zh_punc, '')
    end

    def size(str = nil)
      str ||= self
      str.chars.size
    end

    def chars(str = nil)
      (str || self).scan(/./mu).to_a
    end

    def reverse(str = nil)
      str ||= self
      str.chars.reverse.join
    end

    def uri_encode(str = nil)
      str ||= self
      URI.encode str
    end

    def uri_escape(str = nil)
      str ||= self

      URI.escape(str, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def ascii?(str = nil)
      str ||= self
      str.chars.size == str.bytes.to_a.size
    end

    def multibyte?(str = nil)
      !(str || self).ascii?
    end

    def halfwidth?(str = nil)
      str ||= self
      str[Regex.fullwidth].nil?
    end

    def fullwidth?(str = nil)
      str ||= self
      !self.halfwidth?(str) && self.to_halfwidth(str) != str
    end

    def to_halfwidth(str = nil)
      str ||= self

      str.gsub(/(#{Regex.fullwidth})/){  ZhongwenTools::FW_HW[$1] }
    end

    def to_codepoint(str = nil)
      str ||= self
      #chars = (self.class.to_s == 'String')? self.chars : self.chars(str)
      codepoints = str.chars.map{|c| "\\u%04x" % c.unpack("U")[0]}

      codepoints.join
    end

    def from_codepoint(str = nil)
      str ||= self

      [str.sub(/\\?u/,'').hex].pack("U")
    end
  end
end

if RUBY_VERSION < '1.9'
  require File.expand_path("../string/ruby18", __FILE__)
elsif RUBY_VERSION < '2.0'
  require File.expand_path("../string/ruby19", __FILE__)
end
