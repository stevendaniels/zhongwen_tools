# encoding: utf-8
require 'uri'
require './string/fullwidth'

module CJKTools
  module String

    def self.split(str)
      str.scan(/./mu)
    end
    def self.length(str)
      spli(str).size
    end
    def self.reverse(str)
      split(str).reverse.join
    end
    def self.uri_encode
      URI.escape(self, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
    def to_utf8
      ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      valid_string = ic.iconv(self + ' ')[0..-2]
    end
    # conv = Iconv.new("BIG5//TRANSLIT//IGNORE", "UTF8")
    # will big5 conversions fail without the options?
    def zh_to_utf8(encoding = nil, encodings = nil)
      #should substitute out known bad actors like space
      encodings = ['utf-8', 'GB18030', 'BIG5', 'GBK', 'GB2312'] if encodings.nil?
      encodings = encoding + encodings unless encoding.nil?
      raise 'Unable to Convert' if encodings.size == 0

      begin
        text = Iconv.conv('utf-8', encodings[0], self)
      rescue
        text = self.zh_to_utf8(nil, encodings[1..-1])
      end
      text
    end

    def latin?
      length(str) == str.bytes.count
    end
    def fullwidth?
      !self.halfwidth?
    end
    def halfwidth?
      self[/[０-９Ａ-Ｚａ-ｚ％．：＃＄＆＋－／＼＝；＜＞]/].nil?
    end
    def to_halfwidth(debug = false)
      matches = self.scan(/([０-９Ａ-Ｚａ-ｚ％．：＃＄＆＋－／＼＝；＜＞])/u).uniq.flatten
      puts matches.inspect if debug ===true
      str = self
      matches.each do |match|
        replacement = CJKTools::FW_HW[match]
        puts replacement if debug ===true
        puts str if debug ===true
        puts match if debug ===true
        str = str.gsub(match, replacement) #unless str.nil?
      end
      str
    end
  end
end
