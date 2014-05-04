# encoding: utf-8
#$:.unshift File.join(File.dirname(__FILE__),'..','lib','zhongwen_tools', 'string')
require 'uri'
require File.expand_path("../string/fullwidth", __FILE__)
require File.expand_path("../string/caps", __FILE__)

class String
  alias_method :_downcase, :downcase
  alias_method :_upcase, :upcase

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

    UNICODE_REGEX = {
      :zh => /[\u2E80-\u2E99]|[\u2E9B-\u2EF3]|[\u2F00-\u2FD5]|[\u3005|\u3007]|[\u3021-\u3029]|[\u3038-\u303B]|[\u3400-\u4DB5]|[\u4E00-\u9FCC]|[\uF900-\uFA6D]|[\uFA70-\uFAD9]/,
      :punc => /[\u0021-\u0023]|[\u0025-\u002A]|[\u002C-\u002F]|[\u003A\u003B\u003F\u0040]|[\u005B-\u005D\u005F\u007B\u007D\u00A1\u00A7\u00AB\u00B6\u00B7\u00BB\u00BF\u037E\u0387]|[\u055A-\u055F\u0589\u058A\u05BE\u05C0\u05C3\u05C6\u05F3\u05F4\u0609\u060A\u060C\u060D\u061B\u061E\u061F]|[\u066A-\u066D]|[\u06D4]|[\u0700-\u070D]|[\u07F7-\u07F9]|[\u0830-\u083E]|[\u085E\u0964\u0965\u0970\u0AF0\u0DF4\u0E4F\u0E5A\u0E5B]|[\u0F04-\u0F12]|[\u0F14]|[\u0F3A-\u0F3D]|[\u0F85]|[\u0FD0-\u0FD4]|[\u0FD9\u0FDA]|[\u104A-\u104F]|[\u10FB]|[\u1360-\u1368]|[\u1400\u166D\u166E\u169B\u169C]|[\u16EB-\u16ED]|[\u1735\u1736]|[\u17D4-\u17D6]|[\u17D8-\u17DA]|[\u1800-\u180A\u1944\u1945\u1A1E\u1A1F]|[\u1AA0-\u1AA6]|[\u1AA8-\u1AAD]|[\u1B5A-\u1B60]|[\u1BFC-\u1BFF]|[\u1C3B-\u1C3F]|[\u1C7E\u1C7F]|[\u1CC0-\u1CC7]|[\u1CD3]|[\u2010-\u2027]|[\u2030-\u2043]|[\u2045-\u2051]|[\u2053-\u205E]|[\u207D\u207E\u208D\u208E\u2329\u232A]|[\u2768-\u2775\u27C5\u27C6]|[\u27E6-\u27EF]|[\u2983-\u2998]|[\u29D8-\u29DB\u29FC\u29FD]|[\u2CF9-\u2CFC]|[\u2CFE\u2CFF\u2D70]|[\u2E00-\u2E2E]|[\u2E30-\u2E3B]|[\u3001-\u3003]|[\u3008-\u3011]|[\u3014-\u301F]|[\u3030\u303D\u30A0\u30FB\uA4FE\uA4FF]|[\uA60D-\uA60F]|[\uA673\uA67E]|[\uA6F2-\uA6F7]|[\uA874-\uA877]|[\uA8CE\uA8CF]|[\uA8F8-\uA8FA]|[\uA92E\uA92F\uA95F]|[\uA9C1-\uA9CD]|[\uA9DE\uA9DF]|[\uAA5C-\uAA5F]|[\uAADE\uAADF\uAAF0\uAAF1\uABEB\uFD3E\uFD3F]|[\uFE10-\uFE19]|[\uFE30-\uFE52]|[\uFE54-\uFE61]|[\uFE63\uFE68\uFE6A\uFE6B]|[\uFF01-\uFF03]|[\uFF05-\uFF0A]|[\uFF0C-\uFF0F]|[\uFF1A\uFF1B\uFF1F\uFF20]|[\uFF3B-\uFF3D]|[\uFF3F\uFF5B\uFF5D]|[\uFF5F-\uFF65]/
    }
    def to_utf8(str = nil)
      (str || self).force_encoding('utf-8')
      #TODO: better conversion methods can be extracted from categories service
    end

    def has_zh?(str = nil)
      str ||= self

      !str[/(#{UNICODE_REGEX[:zh]}|#{UNICODE_REGEX[:punc]})/].nil?
    end

    def zh?(str = nil)
      str ||= self

      str.scan(/(#{UNICODE_REGEX[:zh]}+|#{UNICODE_REGEX[:punc]}+|\s+)/).join == str
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

      !str[UNICODE_REGEX[:punc]].nil?
    end

    def strip_zh_punctuation(str = nil)
      str ||= self

      str.gsub(UNICODE_REGEX[:punc], '')
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
      str[/[０-９Ａ-Ｚａ-ｚ％．：＃＄＆＋－／＼＝；＜＞]/].nil?
    end

    def fullwidth?(str = nil)
      str ||= self
      !self.halfwidth?(str) && self.to_halfwidth(str) != str
    end

    def to_halfwidth(str = nil)
      str ||= self

      str.gsub(/([０-９Ａ-Ｚａ-ｚ％．：＃＄＆＋－／＼＝；＜＞])/){  ZhongwenTools::FW_HW[$1] }
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
