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
      def chars(str = nil)
        (str || self).chars
      end

      def to_utf8(str = nil)
        (str || self).force_encoding('utf-8')
        #TODO: better conversion functions available in categorize
      end

      def size(str = nil)
        (str || self).size
      end

      def reverse(str = nil)
        (str || self).reverse
      end
    end

    def uri_encode
      URI.escape(self, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def ascii?(str = nil)
      str ||= self
      str.size == str.bytes.size
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
      !self.halfwidth?(str)
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


    class Basement #:nodoc:
      include ZhongwenTools::String
    end

    def self.chars(*args)
      Basement.new.chars(*args)
    end
    def self.size(*args)
      Basement.new.size(*args)
    end
    def self.reverse(*args)
      Basement.new.reverse(*args)
    end
    def self.to_utf8(*args)
      Basement.new.to_utf8(*args)
    end
    def self.uri_encode(*args)
      Basement.new.uri_encode(*args)
    end
    def self.ascii?(*args)
      Basement.new.ascii?(*args)
    end
    def self.multibyte?(*args)
      Basement.new.multibyte?(*args)
    end
    def self.halfwidth?(*args)
      Basement.new.halfwidth?(*args)
    end
    def self.fullwidth?(*args)
      Basement.new.fullwidth?(*args)
    end
    def self.to_halfwidth(*args)
      Basement.new.to_halfwidth(*args)
    end

  end
end
