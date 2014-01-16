# encoding: utf-8
#$:.unshift File.join(File.dirname(__FILE__),'..','lib','zhongwen_tools', 'string')
require 'uri'
require './lib/zhongwen_tools/string/fullwidth'

module ZhongwenTools 
  module String

    if RUBY_VERSION < '1.9'
      def chars(str = nil)
        (str || self).scan(/./mu)
      end

      def size(str = nil)
        chars(str || self).size
      end

      def reverse(str = nil)
        chars(str || self).reverse.join
      end

      def to_utf8(encoding = nil, encodings = nil)
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

    else 
      def to_utf8(str = nil)
        (str || self).force_encoding('utf-8')
        #TODO: better conversion functions available in categorize
      end
    end

    def self.uri_encode
      URI.escape(self, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def ascii?(str = nil)
      str ||= self
      str.size == str.bytes.size
    end

    def multibyte(str = nil)
      !(str || self).ascii?
    end

    def halfwidth?
      self[/[０-９Ａ-Ｚａ-ｚ％．：＃＄＆＋－／＼＝；＜＞]/].nil?
    end

    def fullwidth?
      !self.halfwidth?
    end

    def to_halfwidth(str = nil, debug = false)
      str = str || self
      matches = str.scan(/([０-９Ａ-Ｚａ-ｚ％．：＃＄＆＋－／＼＝；＜＞])/u).uniq.flatten
      puts matches.inspect if debug === true

      matches.each do |match|
        replacement = FW_HW[match]
        puts replacement if debug === true
        puts str if debug === true
        puts match if debug === true
        str = str.gsub(match, replacement) #unless str.nil?
      end
      str
    end
  end
end
